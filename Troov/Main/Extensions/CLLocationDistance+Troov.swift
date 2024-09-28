//
//  CLLocationDistance+Troov.swift
//  Troov
//
//  Created by Levon Arakelyan on 03.07.24.
//

import CoreLocation.CLLocation

extension CLLocationDistance {
    static func fromMiles(_ miles: Double) -> CLLocationDistance {
        return miles * 1609.34 // 1 mile is approximately 1609.34 meters
    }

//    var milesRoundedInInt: Int {
//        return Int(miles.rounded())
//    }
//    
    var miles: CLLocationDistance {
        return self*0.000621371
    }
}
