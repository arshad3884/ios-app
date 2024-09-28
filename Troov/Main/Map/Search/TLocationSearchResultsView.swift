//
//  TLocationSearchResultsView.swift
//  Troov
//
//  Created by Leo on 03.02.23.
//

import SwiftUI
import MapKit

struct TLocationSearchResultsView: View, KeyboardReadable {
    @ObservedObject var searchViewModel: TMapSearchViewModel
    var viewType: ViewType = .noCurrentLocation
    let close: () -> ()
    let chooseCurrentLocation: () -> ()
    
    @State private var isPresented = false
    
    private var selectedLocationId: UUID? {
        searchViewModel.selection
    }
    
    private var hasRecents: Bool {
        searchViewModel.hasRecents
    }
    
    private var sorted: [SelectableLocation] {
        searchViewModel.annotationItems.sorted {
            if $1.id == selectedLocationId {
                return false
            } else if $0.id == selectedLocationId {
                return true
            } else {
                if let name1 = $0.location.name,
                   let name2 = $1.location.name {
                    return name1 > name2
                }
                return false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                if sorted.count == 0 && !hasRecents {
                    Text("Search results will be shown here...")
                        .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 14)
                        .foregroundStyle(Color.primaryBlack)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .lineLimit(2)
                        .padding(.vertical)
                        .padding(.horizontal, 17)
                }
                List(sorted, id: \.id) { selectableLocation in
                    Button {
                        let id = sorted.first?.id
                        proxy.scrollTo(id)
                        select(location: selectableLocation.location)
                    } label: {
                        TLocationSearchCell(location: selectableLocation,
                                            isSelected: selectedLocationId == selectableLocation.id)
                        .overlay(alignment: .topTrailing) {
                            if hasRecents {
                                Circle()
                                    .fill(Color.primaryTroovColor.opacity(0.5))
                                    .frame(width: 8, height: 8)
                                    .padding(10)
                                    .shadow(radius: 2)
                            }
                        }
                    }.buttonStyle(.scalable)
                        .id(selectableLocation.id)
                }
                .defaultScrollAnchor(.top)
                .listRowSeparator(.hidden)
                .listStyle(.plain)
                .background(.white)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: viewType == .withCurrentLocation ? .topBarLeading : .principal) {
                        Text("Search Maps")
                            .bold()
                    }
                    if viewType == .withCurrentLocation {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: chooseCurrentLocation) {
                                Text("Current Location")
                            }
                        }
                    }
                }
            }
        }
        .padding(.top)
        .searchable(text: $searchViewModel.searchTerm,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Search Maps")) {
            TLocationSearchResultsCompletionView(searchViewModel: searchViewModel)
        }
    }
    
    private func select(location: Location) {
        
        if let selection = searchViewModel.selection,
           let selectedAnnotation = sorted.first(where: {$0.id == selection}),
           location.coordinate2D.isEqualTo(selectedAnnotation.location.coordinate2D) {
            close()
            return
        }
        
        endEditing()
        searchViewModel.detent = .fraction(0.4)
        searchViewModel.select(location: location)
    }
}

struct TLocationSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TLocationSearchResultsView(searchViewModel: TMapSearchViewModel()) {} chooseCurrentLocation: {}
    }
}

fileprivate struct TLocationSearchResultsCompletionView: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @State private var isLoading = false
    @ObservedObject var searchViewModel: TMapSearchViewModel
    
    private var completions: [MKLocalSearchCompletion] {
        searchViewModel.locationResult.comletions
    }
    
    private var recents: [String] {
        searchViewModel.annotationItems.prefix(4).map({$0.location.name ?? ""})
    }
    
    var body: some View {
        VStack {
            if completions.count > 0 {
                ForEach(completions, id: \.self) { completion in
                    HStack {
                        Button {
                            searchable(completion: completion)
                        } label: {
                            TLocationSerchPreliminaryCell(searchCompletion: completion)
                                .background(Color.white)
                        }.buttonStyle(.scalable)
                    }
                    Divider()
                }
            } else if recents.count > 0 {
                VStack(alignment: .leading) {
                    Text("Recents")
                        .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.primaryTroovColor)
                        .padding(.vertical)
                    ForEach(recents, id: \.self) { recent in
                        HStack {
                            Button {
                                search(title: recent)
                            } label: {
                                Text(recent.cleanLeadingTrailing)
                                    .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
                                    .foregroundStyle(Color.primaryBlack)
                                    .padding(.vertical)
                            }.buttonStyle(.scalable)
                        }
                        if recents.last != recent {
                            Divider()
                        }
                    }
                }
            }
        }.background(Color.white)
            .overlay(alignment: .top) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.primaryTroovColor)
                }
            }
    }
    
    
    private func search(subtitle: String) async {
        await searchViewModel.searchPlace(by: subtitle, assignBoundingRegion: false)
    }
    
    private func search(title: String) async {
        await searchViewModel.searchPlace(by: title, assignBoundingRegion: true)
    }
    
    private func searchable(completion: MKLocalSearchCompletion) {
        search(title: completion.title, subtitle: completion.subtitle)
    }
    
    private func search(title: String, subtitle: String? = nil) {
        isLoading = true
        Task {
            searchViewModel.cleanAnnotationItems()
            
            await search(title: title)
            var selectFirst = false
            if let subtitle = subtitle {
                if subtitle != "Search Nearby" {
                    selectFirst = true
                }
                await search(subtitle: subtitle)
            } else {
                selectFirst = true
            }
            searchViewModel.locationResult.comletions = []
            isLoading = false
            dismissSearch()
            searchViewModel.detent = .fraction(0.4)
            await searchViewModel.capAnnotationItems()
            
            if selectFirst {
                searchViewModel.selectFirst()
            }
        }
    }
}

extension TLocationSearchResultsView {
    enum ViewType {
        case withCurrentLocation
        case noCurrentLocation
    }
}
