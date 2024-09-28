//
//  SearchActivityFiltersView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import SwiftUI

struct SearchActivityFiltersView: View {
    @Binding var location: Location?
    @Binding var distance: TroovCoreDetailFilterAttributesMaximumDistance?
    @Binding var costInfo: CostInfoSheetView.Info
    @Binding var selectedDays: [String]
    @Binding var selectedTimes: [String]

    @State private var showingLocationSearch = false
    @State private var showingDistance = false
    @State private var showingCostInfo = false
    @State private var showingDays = false
    @State private var showingTimes = false

    private var distanceText: String {
        if let distanceText = distance?.distanceText {
            return distanceText
        } else {
            return "Select Distance"
        }
    }

    private var locationText: String {
        if let location = location,
           let name = location.name {
            return name
        }
        return "Current Location"
    }

    private var daysText: String {
        if selectedDays.count > 0 {
            return selectedDays.joined(separator: ", ")
        }
        return "None"
    }
    
    private var timesText: String {
        if selectedTimes.count > 0 {
            return selectedTimes.joined(separator: ", ")
        }
        return "None"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Filters")
                .fontWithLineHeight(font: .poppins700(size: 16), lineHeight: 16)
                .foregroundColor(.black)
            Button {
                showingLocationSearch = true
            } label: {
                TInformativeLabel(title: "Location",
                                  bodyText: locationText,
                                  inactive: location?.name == nil,
                                  erase: eraseLocation)
            }
            
            Button {
                showingDistance = true
            } label: {
                TInformativeLabel(title: "Distance",
                                  bodyText: distanceText,
                                  inactive: distance == nil,
                                  erase: eraseDistance)
            }

            TInformativeLabel(title: "Cost",
                              bodyText: "",
                              erase: eraseCost)
            .overlay(alignment: .trailing) {
                CostInfoRow(info: costInfo,
                            disabled: false,
                            select: selectPrice(_:))
                .padding(.trailing, 8)
            }.overlay(alignment: .leading) {
                Button(action: { showingCostInfo.toggle() }) {
                    Image("info.icon")
                        .renderingMode(.template)
                        .foregroundStyle(Color.primaryTroovColor)
                }.padding(.leading, 44)
            }

            Button {
                showingDays = true
            } label: {
                TInformativeLabel(title: "Days",
                                  bodyText: daysText,
                                  inactive: selectedDays.count == 0,
                                  erase: eraseDates)
            }
            
            Button {
                showingTimes = true
            } label: {
                TInformativeLabel(title: "Times of Day",
                                  bodyText: timesText,
                                  inactive: selectedTimes.count == 0,
                                  erase: eraseDates)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 16)
        .sheet(isPresented: $showingLocationSearch) {
            NavigationStack {
                TLocationSearchView(viewType: .withCurrentLocation) { location in
                    self.location = location
                }
            }
        }
        .sheet(isPresented: $showingDistance) {
            DistanceView(initialDistance: distance,
                         complation: change(_:))
                .presentationDetents([.height(124)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
        .sheet(isPresented: $showingCostInfo) {
            CostInfoSheetView()
                .presentationDetents([.fraction(0.65)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
        }
        .sheet(isPresented: $showingDays) {
            Filters.DaySheetView(selectedDays: $selectedDays)
                .presentationDetents([.fraction(0.4)])
                .presentationCornerRadius(24)
        }
        .sheet(isPresented: $showingTimes) {
            Filters.TimeSheetView(selectedTimes: $selectedTimes)
                .presentationDetents([.fraction(0.5)])
                .presentationCornerRadius(24)
        }
    }

    private func change(_ distance: TroovCoreDetailFilterAttributesMaximumDistance) {
        self.distance = distance
    }

    private func selectPrice(_ info: CostInfoSheetView.Info) {
        costInfo = info
    }

    private func eraseLocation() {
        location = nil
    }

    private func eraseDistance() {
        distance = nil
    }

    private func eraseCost() {
        costInfo = .init(selectedTags: [])
    }
    
    private func eraseDates() {
        selectedDays = []
        selectedTimes = []
    }
}

#Preview {
    SearchActivityFiltersView(location: .constant(.init()),
                              distance: .constant(.init()),
                              costInfo: .constant(.init(selectedTags: [])),
                              selectedDays: .constant([]),
                              selectedTimes: .constant([]))
}
