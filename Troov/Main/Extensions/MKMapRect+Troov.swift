//
//  MKMapRect+Troov.swift
//  Troov
//
//  Created by Levon Arakelyan on 12.07.24.
//

import MapKit

extension MKMapRect {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let point = MKMapPoint(coordinate)
        return self.contains(point)
    }
}
