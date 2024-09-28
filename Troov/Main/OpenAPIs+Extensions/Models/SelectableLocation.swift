//
//  Location.swift
//  Troov
//
//  Created by Chad Newbry on 6/12/23.
//

import Foundation
import MapKit
import _MapKit_SwiftUI

struct SelectableLocation: Codable, Identifiable {
    public var id = UUID() // String { location.placeId ?? UUID().uuidString }
    var location: Location

    var isSelected: Bool = false
    var searchResultIconName: String = ""
    var reversedGeoLocation: TReversedGeoLocation?

    init(item: MKMapItem) {
        self.location = .init(name: item.name,
                              placeId: self.id.uuidString,
                              /**
                            This was added by CN, but it's throwing server side issue, since its format does't match the extected placeId format
                               */
//                              placeId: item.placemark.region?.identifier,
                              coordinates: Coordinates(latitude: item.placemark.coordinate.latitude,
                                                       longitude: item.placemark.coordinate.longitude))

        self.reversedGeoLocation = .init(with: item.placemark)
        self.searchResultIconName = "t.map"
        self.isSelected = false
    }
    
    init(feature: MapFeature) {
        self.location = .init(name: feature.title ?? "",
                              placeId: self.id.uuidString,
                              /**
                            This was added by CN, but it's throwing server side issue, since its format does't match the extected placeId format
                               */
//                              placeId: item.placemark.region?.identifier,
                              coordinates: Coordinates(latitude: feature.coordinate.latitude,
                                                       longitude: feature.coordinate.longitude))

        self.reversedGeoLocation = .init(feature: feature)
        self.searchResultIconName = "t.map"
        self.isSelected = false
    }

    init(location: Location) {
        self.location = location
    }

}
/**
 https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
 https://dwirandyh.medium.com/deep-dive-into-core-location-in-ios-geofencing-region-monitoring-7846802c968e
 https://github.com/ualch9/GeohashKit/blob/main/Sources/GeohashKit/MapKit/Geohash%2BMapKit.swift
 */
