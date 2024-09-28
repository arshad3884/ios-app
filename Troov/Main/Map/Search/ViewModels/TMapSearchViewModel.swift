//
//  TMapSearchViewModel.swift
//  Troov
//
//  Created by Leo on 31.01.23.
//

import SwiftUI
import MapKit
import Combine

class TMapSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate, AppProtocol {
    private let fileName = "t.locations.json"

    private(set) var hasRecents = false
    @Published private(set) var annotationItems: [SelectableLocation] = []
    @Published var detent: PresentationDetent = .fraction(0.2)
    @Published var position: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    @Published var selection: UUID?

    @Published var searchTerm = ""
    @Published var locationResult: TLocalSearchCompleter = .init(comletions: [],
                                                                 region: MKCoordinateRegion())
    private var cancellables : Set<AnyCancellable> = []
    private var locationRequested = true
    private var searchCompleter = MKLocalSearchCompleter()
    private var currentPromise: ((Result<TLocalSearchCompleter, Error>) -> Void)?
    private let annotationsCap: Int = 50
    
    private func search(term: String,
                        appendAnnotations: Bool = true,
                        assignBoundingRegion: Bool) async {
        guard !term.isEmpty else { return }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = term
        let search = MKLocalSearch(request: searchRequest)
        
        let response = try? await search.start()
        
        if let response = response {
            if appendAnnotations {
                let items = response.mapItems.map({SelectableLocation(item: $0) })
                for item in items {
                    await MainActor.run {
                        self.annotationItems.append(item)
                    }
                }
                
                if items.count > 0 && assignBoundingRegion {
                    await MainActor.run {
                        withAnimation(.easeInOut.delay(0.5)) {
                            self.position = .region(response.boundingRegion)
                        }
                    }
                }
            }
        }
    }
    
    @MainActor func cleanAnnotationItems() {
        self.annotationItems = []
    }
    
    private func update(location: CLLocation?) {
        guard let location = location else { return  }
        guard locationRequested else { return }
        locationRequested = false
        DispatchQueue.main.async {
            withAnimation {
                self.position = .region(self.region(location.coordinate, 0.01))
            }
        }
    }

    @MainActor func select(location: Location) {
        for index in self.annotationItems.indices {
            let newLocation = self.annotationItems[index]
            if newLocation.location.coordinate2D.isEqualTo(location.coordinate2D) {
                selection = self.annotationItems[index].id
                hapticFeedback()
                withAnimation {
                    self.position = .region(region(location.coordinate2D, 0.01))
                }
                break
            } else if newLocation.isSelected {
                withAnimation {
                    selection = nil
                }
            }
        }
    }
    
    @MainActor func select(by uuid: UUID) {
        if let location = annotationItems.first(where: {$0.id == uuid}) {
            select(location: location.location)
        }
    }

    @MainActor func selectFirst() {
        if let location = annotationItems.first {
            select(location: location.location)
        }
    }

    private func region(_ coordinates: CLLocationCoordinate2D,_ delta: CLLocationDegrees) -> MKCoordinateRegion {
        return .init(center: coordinates, span: .init(latitudeDelta: delta, longitudeDelta: delta))
    }
    
    override init() {
        super.init()
        let region = position.region ?? MKCoordinateRegion()
        locationResult = .init(comletions: [],
                               region: region)

        searchCompleter.delegate = self
        searchCompleter.region = region
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address,
                                                                         .pointOfInterest,
                                                                         .query])
        currentPromise = {  [weak self] value in
            guard let self = self else { return }
            switch value {
            case .success(let result):
                Task {
                    await MainActor.run {
                        self.locationResult = result
                    }
                }
            default:
                return
            }
        }
    
        $searchTerm
            .debounce(for: .seconds(0.2),
                      scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] (term) in
                guard let self = self else { return }
                self.searchCompleter.queryFragment = term
            })
            .store(in: &cancellables)

        if let storedSearchResults = locationsFromFile, storedSearchResults.count > 0 {
            self.annotationItems = storedSearchResults
            self.hasRecents = true
        }
    }
    
    func searchPlace(by term: String, assignBoundingRegion: Bool) async {
        await search(term: term, assignBoundingRegion: assignBoundingRegion)
    }

    func capAnnotationItems() async {
        if annotationItems.count > annotationsCap {
            let cappedArray = Array(annotationItems.prefix(annotationsCap))
            await MainActor.run {
                annotationItems = cappedArray
            }
        }
        storeLocationLocally()
        hasRecents = false
    }

    func appendNewFeatureAndSelect(feature: MapFeature) {
        let item = SelectableLocation(feature: feature)
        if !annotationItems.contains(where: {$0.location.coordinate2D.isEqualTo(feature.coordinate)}) {
            annotationItems.insert(item, at: 0)
            selection = annotationItems.first?.id
        }
    }
    
    deinit {
        searchCompleter.delegate = nil
        currentPromise = nil
    }
    
    /**
     MKLocalSearchCompleterDelegate
     */
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.global(qos: .background).async {
            self.currentPromise?(.success(TLocalSearchCompleter(comletions: completer.results,
                                                                region: completer.region)))
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        currentPromise?(.failure(error))
    }

    private func storeLocationLocally() {
        if annotationItems.count > 0 {
            saveLocationsToFile(locations: annotationItems)
        }
    }
}

/**
 Cache location annotations
 */
fileprivate extension TMapSearchViewModel {
    func saveLocationsToFile(locations: [SelectableLocation]) {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(locations)
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                do {
                    try encoded.write(to: fileURL)
                    print("====>>> Successfully saved locations count: \(locations.count) to file:")
                } catch {
                    print("====>>> Failed to write JSON data: \(error.localizedDescription)")
                }
            }
        } catch {
            print("====>>> \(String(describing: error))")
        }
    }
    
    var locationsFromFile: [SelectableLocation]? {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let annotations = try decoder.decode([SelectableLocation].self, from: data)
                return annotations
            } catch {
                print("====>>> \(String(describing: error))")
            }
        }
        return nil
    }
}
