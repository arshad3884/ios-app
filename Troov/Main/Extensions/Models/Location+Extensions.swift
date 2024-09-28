//
//  Location+Extensions.swift
//  Troov
//
//  Created by Leo on 04.04.23.
//

import MapKit

extension Location {
    var coordinate2D: CLLocationCoordinate2D {
        if let latitude = coordinates?.latitude,
           let longitude = coordinates?.longitude {
            return CLLocationCoordinate2D(latitude: latitude,
                                          longitude: longitude)
        }

        return .init()
    }

    var cllocation: CLLocation? {
        if let latitude = coordinates?.latitude,
           let longitude = coordinates?.longitude {
            return CLLocation(latitude: latitude,
                              longitude: longitude)
        }
        return nil
    }
}


extension LocationQueryable {
    var coordinate2D: CLLocationCoordinate2D {
        if let latitude = queryableCoordinates?.latitude,
           let longitude = queryableCoordinates?.longitude {
            return CLLocationCoordinate2D(latitude: latitude,
                                          longitude: longitude)
        }

        return .init()
    }

    var cllocation: CLLocation? {
        if let latitude = queryableCoordinates?.latitude,
           let longitude = queryableCoordinates?.longitude {
            return CLLocation(latitude: latitude,
                              longitude: longitude)
        }
        return nil
    }
}
