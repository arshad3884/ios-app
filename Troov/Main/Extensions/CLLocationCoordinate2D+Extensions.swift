//
//  CLLocationCoordinate2D+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 10.05.23.
//

import MapKit
import Foundation

extension CLLocationCoordinate2D {
    static let sanFrancisco = CLLocationCoordinate2D(latitude: 37.773972,
                                                    longitude: -122.431297)
    static let austin = CLLocationCoordinate2D(latitude: 30.2672,
                                               longitude: -97.7431)
    
    func isEqualTo(_ coordinate: CLLocationCoordinate2D, decimalPlaces: Int = 0) -> Bool {
        if decimalPlaces > 0 {
            let coordinate1 = self.roundCoordinate(to: decimalPlaces)
            let coordinate2 = coordinate.roundCoordinate(to: decimalPlaces)
            return coordinate1.latitude == coordinate2.latitude &&
                   coordinate1.longitude == coordinate2.longitude
        }
        return latitude == coordinate.latitude &&
               longitude == coordinate.longitude
    }
    
    
    func roundCoordinate(to decimalPlaces: Int) -> CLLocationCoordinate2D {
        let factor = pow(10.0, Double(decimalPlaces))
        let roundedLatitude = (self.latitude * factor).rounded() / factor
        let roundedLongitude = (self.longitude * factor).rounded() / factor
        return CLLocationCoordinate2D(latitude: roundedLatitude, longitude: roundedLongitude)
    }
}
