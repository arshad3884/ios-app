//
//  TLocationSearchView.swift
//  Troov
//
//  Created by Leo on 31.01.23.
//

import SwiftUI
import MapKit.MKAnnotationView
import MapKit.MKUserLocation
import CoreLocationUI

struct TLocationSearchView: View, KeyboardReadable, TSecondaryLabelProtocol {
    var viewType: TLocationSearchResultsView.ViewType = .noCurrentLocation
    let result: (Location?) -> ()
    @StateObject private var searchViewModel = TMapSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresented = false
    @State private var feature: MapFeature?

    private var disabled: Bool {
        searchViewModel.selection == nil
    }
    
    private var annotationItems: [SelectableLocation] {
        searchViewModel.annotationItems
    }
    
    private var currentLocation: SelectableLocation? {
        guard let selection = searchViewModel.selection else { return nil }
        return annotationItems.first(where: { $0.id == selection })
    }
    
    private var title: String {
        if let location = currentLocation?.location {
            return location.name ?? "Unknown"
        }
        return "Choose the location"
    }
    
    var body: some View {
        Map(position: $searchViewModel.position,
            selection: $feature) {
            ForEach(annotationItems, id: \.id) { selectableLocation in
                let isSelected = selectableLocation.id == searchViewModel.selection
                Annotation(coordinate: selectableLocation.location.coordinate2D) {
                    Image("t.location.fill")
                        .scaleEffect(isSelected ? 1.2 : 1)
                        .onTapGesture {
                            withAnimation {
                                searchViewModel.selection = selectableLocation.id
                            }
                        }
                } label: {
                    Text(selectableLocation.location.name ?? "")
                }
            }
        }.mapFeatureSelectionContent { feature in
                if let image = feature.image,
                   let color = feature.backgroundColor {
                    Marker(coordinate: feature.coordinate) {
                        image
                    }
                    .tint(color)
                } else {
                    Marker(feature.title ?? "", coordinate: feature.coordinate)
                        .tint(Color.primaryTroovColor)
                }
            }
            .mapStyle(.standard(pointsOfInterest: .including([.publicTransport,
                                                              .airport,
                                                              .amusementPark,
                                                              .aquarium,
                                                              .bakery,
                                                              .hotel,
                                                              .cafe,
                                                              .restaurant,
                                                              .park,
                                                              .parking,
                                                              .nationalPark])))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .mapFeatureSelectionDisabled({ feature in
                return false
            })
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $isPresented,
                   content: {
                TLocationSearchResultsView(searchViewModel: searchViewModel,
                                           viewType: viewType,
                                           close: saveAndDismiss,
                                           chooseCurrentLocation: chooseCurrentLocation)
                    .interactiveDismissDisabled()
                    .presentationDetents([.fraction(0.2),
                                          .fraction(0.4),
                                          .large],
                                         selection: $searchViewModel.detent)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    .presentationCornerRadius(24)
                    .environmentObject(searchViewModel)
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: close,
                           label: {
                        labelWithImage(systemName: "xmark")
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: saveAndDismiss,
                           label: {
                        labelWithImage(systemName: "checkmark",
                                       foregroundColor: .primaryTroovColor)
                        .opacity(disabled ? 0.0 : 1.0)
                    })
                }
            })
            .onAppear(perform: appear)
            .onChange(of: searchViewModel.selection) { _, newValue in
                if let uuid = newValue {
                    searchViewModel.detent = .fraction(0.4)
                    searchViewModel.select(by: uuid)
                }
            }.onChange(of: feature) { _, newValue in
                if let feature = newValue {
                    searchViewModel.appendNewFeatureAndSelect(feature: feature)
                }
            }
    }
    
    private func close() {
        isPresented = false
        dismiss()
    }
    
    private func saveAndDismiss() {
        if let location = currentLocation?.location {
            result(location)
            searchViewModel.cleanAnnotationItems()
            close()
        }
    }

    private func chooseCurrentLocation() {
        result(nil)
        close()
    }
    
    private func appear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                      execute: {
            withAnimation(.easeInOut) {
                self.isPresented = true
            }
        })
    }
}

struct TLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        TLocationSearchView { _ in}
    }
}

/*
fileprivate struct LocationPreviewLookAroundView: View {
    @State private var lookAroundScene: MKLookAroundScene?
    var location: Location
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text(location.name ?? "")
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(18)
            }
            .onAppear {
                getLookAroundScene()
            }
            .onChange(of: location) {
                getLookAroundScene()
            }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(coordinate: location.coordinate2D)
            lookAroundScene = try? await request.scene
        }
    }
}
*/
