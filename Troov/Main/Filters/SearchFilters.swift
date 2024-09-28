//
//  SearchFilters.swift
//  Troov
//
//  Created by Levon Arakelyan on 27.12.23.
//

import Foundation
import CoreLocation
import MapKit

actor SearchFilters {
    static let shared = SearchFilters(localFilterSettings: .default)

    private var localFilterSettings: LocalFilterSettings?

    func update(location: Location?,
                distance: TroovCoreDetailFilterAttributesMaximumDistance?,
                personalFilters: [PersonalFilterItem],
                costInfo: CostInfoSheetView.Info,
                selectedDays: [String],
                selectedTimes: [String],
                selectedInterestedIn: [String],
                minAge: Int?,
                maxAge: Int?,
                minHeight: Int?,
                maxHeight: Int?) async {
        var originalLocation = location
        if originalLocation == nil, let userLocation = User.storedLocation {
            originalLocation = .init(coordinates: .init(latitude: userLocation.coordinate.latitude,
                                                        longitude: userLocation.coordinate.longitude))
        }
        
        var daysOfWeek: [DayOfWeek]?
        if selectedDays.count > 0 {
            for day in selectedDays {
                if let dayOfWeek = DayOfWeek(rawValue: day.withEnums) {
                    if daysOfWeek == nil {
                        daysOfWeek = []
                    }
                    daysOfWeek?.append(dayOfWeek)
                }
            }
        }
        
        var timesOfDay: [TimeOfDay]?
        if selectedTimes.count > 0 {
            for time in selectedTimes {
                if let timeOfDay = TimeOfDay(rawValue: time.withEnums) {
                    if timesOfDay == nil {
                        timesOfDay = []
                    }
                    timesOfDay?.append(timeOfDay)
                }
            }
        }
        
        let relationshipInterests = selectedInterestedIn.count == 0 ? nil : selectedInterestedIn.map({ RelationshipInterest(filterUsageRawValue: $0)})
        
        
        var expenseRatings: [ExpenseRating]? = nil
        if costInfo.selectedTags.count > 0 {
            expenseRatings = [costInfo.expenseRating]
        }
        
        let troovFilters = TroovCoreDetailFilterAttributes(originCoordinates: originalLocation?.coordinates,
                                                    maximumDistance: distance ?? LocalFilterSettings.default?.troovFilters.maximumDistance,
                                                    daysOfWeek: daysOfWeek,
                                                    dateStartTimings: timesOfDay,
                                                    expenseRatings: expenseRatings,
                                                    relationshipInterests: relationshipInterests)
        /**
         Personal filters
         */
        let minAgeInt64: Int64? = minAge != nil ? Int64(minAge!) : nil
        let maxAgeInt64: Int64? = maxAge != nil ? Int64(maxAge!) : nil
        let minHeght: ProfileFilterAttributesMinHeight? = minHeight != nil ? ProfileFilterAttributesMinHeight(length: minHeight,
                                                                                                              unit: ._in) : nil

        let maxHeght: ProfileFilterAttributesMinHeight? = maxHeight != nil ? ProfileFilterAttributesMinHeight(length: maxHeight,
                                                                                                              unit: ._in) : nil

        var profileFilterAttributes = ProfileFilterAttributes(minAge: minAgeInt64,
                                                              maxAge: maxAgeInt64,
                                                              minHeight: minHeght,
                                                              maxHeight: maxHeght)
        for filter in personalFilters {
            switch filter {
            case .education(let education):
                profileFilterAttributes.educationHistory = education
            case .religion(let religion):
                profileFilterAttributes.religion = religion
            case .ethnicity(let ethnicity):
                profileFilterAttributes.ethnicity = ethnicity
            case .gender(let gender):
                profileFilterAttributes.gender = gender
            case .politics(let politics):
                profileFilterAttributes.politics = politics
            }
        }
        
        
        let filterSettings = DiscoverFilterSettings(troovFilters: troovFilters,
                                            profileFilters: profileFilterAttributes)
        
        let localFilterSettings = LocalFilterSettings(.init(locationName: location?.name),
                                                      filterSettings)
        await self.set(localFilterSettings)
    }

    func update(distance: Double,
                coordinates: CLLocationCoordinate2D) {
        let maxDistance = min(Double(TroovCoreDetailFilterAttributesMaximumDistance.allowedLocalMax), max(distance, 1))
        localFilterSettings?.element2.troovFilters.maximumDistance = .init(length: maxDistance,
                                                                           unit: .mile)
        update(coordinates: coordinates)
    }

    func update(paginationOrder: PaginationOrder) {
        localFilterSettings?.paginationOrder = paginationOrder
    }

    func update(coordinates: CLLocationCoordinate2D) {
        localFilterSettings?.element2.troovFilters.originCoordinates = .init(latitude: coordinates.latitude,
                                                                             longitude: coordinates.longitude)
        localFilterSettings?.element1.locationName = "\(String(format: "%.5f", coordinates.latitude)), \(String(format: "%.5f", coordinates.longitude))"
    }
    
    func setDefault() async {
        self.localFilterSettings = LocalFilterSettings.default
    }
    
    func fetchSettings() async -> LocalFilterSettings? {
        self.localFilterSettings
    }

    func cameraRegion() async -> MKCoordinateRegion?  {
        guard let fetchSettings = await fetchSettings(),
              let location = fetchSettings.troovFilters.originCoordinates,
              let radiusInMiles = fetchSettings.troovFilters.maximumDistance?.length,
              let latitude = location.latitude,
              let longitude = location.longitude else { return nil }
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude,
                                                      longitude: longitude)
        let region = MKCoordinateRegion(center: centerCoordinate,
                                        radius: CLLocationDistance.fromMiles(Double(radiusInMiles)))
        return region
    }
    
    private func set(_ settings: LocalFilterSettings) async {
        self.localFilterSettings = settings
    }

    private init(localFilterSettings: LocalFilterSettings?) {
        self.localFilterSettings = localFilterSettings
    }
}

