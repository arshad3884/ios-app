//
//  LocalFilterSettings+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 24.10.23.
//

import Foundation
import CoreLocation

extension LocalFilterSettings {
    static var `default`: LocalFilterSettings? {

        /**
         In case of missing user location, default to
         Austin, USA
         */
        var coordinate: CLLocationCoordinate2D = .austin
        /**
         Get user location
         */
        if let location = User.storedLocation {
            coordinate = location.coordinate
        }
        
        let filterSettings = DiscoverFilterSettings(troovFilters: .init(originCoordinates: .init(latitude: coordinate.latitude,
                                                                                        longitude: coordinate.longitude),
                                                                        maximumDistance: .init(length: Double(TroovCoreDetailFilterAttributesMaximumDistance.default),
                                                                                     unit: .mile)),
                                                    profileFilters: .init(),
                                                    paginationOrder: .startTime)
        return LocalFilterSettings(.init(locationName: nil), filterSettings)
    }
}
