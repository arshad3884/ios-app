//
//  MKCoordinateRegion+Troov.swift
//  Troov
//
//  Created by Levon Arakelyan on 03.07.24.
//

import MapKit


extension MKCoordinateRegion {
    func isEqual(region: MKCoordinateRegion) -> Bool {
        let hasTheSameCenter = self.center.isEqualTo(region.center, decimalPlaces: 3)
        let span = self.span
        let longitudeDelta = span.longitudeDelta
        let regionLongitudeDelta = region.span.longitudeDelta
    
        let hasTheSameLongitudeDelta = areEqualAtThreeDecimalPlaces(longitudeDelta, regionLongitudeDelta)
        
        return hasTheSameCenter && hasTheSameLongitudeDelta
    }
    
    private func areEqualAtThreeDecimalPlaces(_ first: Double, _ second: Double) -> Bool {
        let multiplier = pow(10.0, 3.0) // 10^3
        let roundedFirst = round(first * multiplier) / multiplier
        let roundedSecond = round(second * multiplier) / multiplier
        return roundedFirst == roundedSecond
    }

    public func radius(heading: Double) -> CLLocationDistance {
        // Calculate the half-span in latitude and longitude directions
        let halfLatDelta = span.latitudeDelta * 0.5
        let halfLongDelta = span.longitudeDelta * 0.5

        // Calculate the four corner points of the map view
        var topLeft = CLLocationCoordinate2D(latitude: center.latitude + halfLatDelta, longitude: center.longitude - halfLongDelta)
        var topRight = CLLocationCoordinate2D(latitude: center.latitude + halfLatDelta, longitude: center.longitude + halfLongDelta)
        var bottomLeft = CLLocationCoordinate2D(latitude: center.latitude - halfLatDelta, longitude: center.longitude - halfLongDelta)
        var bottomRight = CLLocationCoordinate2D(latitude: center.latitude - halfLatDelta, longitude: center.longitude + halfLongDelta)
        
        // Function to rotate a coordinate around the center
        func rotate(coordinate: CLLocationCoordinate2D,
                    around center: CLLocationCoordinate2D, by angle: Double) -> CLLocationCoordinate2D {
            let angle = angle * .pi / 180
            let dx = coordinate.longitude - center.longitude
            let dy = coordinate.latitude - center.latitude
            
            let newDx = dx * cos(angle) - dy * sin(angle)
            let newDy = dx * sin(angle) + dy * cos(angle)
            
            return CLLocationCoordinate2D(latitude: center.latitude + newDy, longitude: center.longitude + newDx)
        }

        // Rotate the corners around the center
        topLeft = rotate(coordinate: topLeft, around: center, by: heading)
        topRight = rotate(coordinate: topRight, around: center, by: heading)
        bottomLeft = rotate(coordinate: bottomLeft, around: center, by: heading)
        bottomRight = rotate(coordinate: bottomRight, around: center, by: heading)
        
        // Calculate the distances from the center to each rotated corner
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let distanceToTopLeft = centerLocation.distance(from: CLLocation(latitude: topLeft.latitude,
                                                                         longitude: topLeft.longitude))
        let distanceToTopRight = centerLocation.distance(from: CLLocation(latitude: topRight.latitude,
                                                                          longitude: topRight.longitude))
        let distanceToBottomLeft = centerLocation.distance(from: CLLocation(latitude: bottomLeft.latitude,
                                                                            longitude: bottomLeft.longitude))
        let distanceToBottomRight = centerLocation.distance(from: CLLocation(latitude: bottomRight.latitude,
                                                                             longitude: bottomRight.longitude))
        
        // Find the minimum distance to ensure the circle fits inside the camera view
        let radius = min(distanceToTopLeft/2, distanceToTopRight/2, distanceToBottomLeft/2, distanceToBottomRight/2)
        
        return radius
    }

    public var radius: CLLocationDistance {
        let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc3 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        let loc4 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
    
        let metersInLatitude = loc1.distance(from: loc2)
        let metersInLongitude = loc3.distance(from: loc4)
        let radius = max(metersInLatitude, metersInLongitude) / 2.0
        return radius
    }

    init(center: CLLocationCoordinate2D, radius: CLLocationDistance) {
        // Earth radius in meters
        let earthRadius = 6378137.0
        
        // Calculate latitude and longitude deltas
        let latitudeDelta = (radius / earthRadius) * (180.0 / Double.pi)
        let longitudeDelta = (radius / (earthRadius * cos(Double.pi * center.latitude / 180.0))) * (180.0 / Double.pi)
        
        // Create MKCoordinateSpan using the calculated deltas
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta * 2, longitudeDelta: longitudeDelta * 2)

        // Initialize MKCoordinateRegion with the center and span
        self.init(center: center, span: span)
    }
}
