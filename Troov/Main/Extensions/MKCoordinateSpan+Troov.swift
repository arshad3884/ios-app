//
//  MKCoordinateSpan+Troov.swift
//  Troov
//
//  Created by Levon Arakelyan on 26.07.24.
//

import MapKit

extension MKCoordinateSpan {
    func rotatedOffsetCentroid(center: CLLocationCoordinate2D,
                               span: MKCoordinateSpan,
                               rotationAngleRadians: Double,
                               northSouthOffsetProportion: Double) -> CLLocationCoordinate2D {
        let earthRadius = 6371000.0 // Earth's radius in meters
        let offsetDistance = span.latitudeDelta * northSouthOffsetProportion * earthRadius * Double.pi / 180

        let newLatitude = center.latitude + (offsetDistance * cos(rotationAngleRadians) / earthRadius) * (180 / Double.pi)
        let newLongitude = center.longitude + (offsetDistance * sin(rotationAngleRadians) / (earthRadius * cos(center.latitude * Double.pi / 180))) * (180 / Double.pi)

        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
    
    func adjustedHorizontalHalfWidthInMeters(center: CLLocationCoordinate2D, heading: CLLocationDegrees) -> CLLocationDistance {
        let headingRadians = heading * Double.pi / 180
        
        // Find the east and west points after rotation
        let eastPoint = rotatedOffsetCentroid(center: center, span: self, rotationAngleRadians: headingRadians, northSouthOffsetProportion: 0.5)
        let westPoint = rotatedOffsetCentroid(center: center, span: self, rotationAngleRadians: headingRadians + Double.pi, northSouthOffsetProportion: 0.5)
        
        // Calculate the distance between east and west points
        return distanceBetweenCoordinates(eastPoint, westPoint)/2
    }
    
    private func distanceBetweenCoordinates(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> CLLocationDistance {
        let earthRadius = 6371000.0 // Earth's radius in meters
        
        let deltaLat = (coord2.latitude - coord1.latitude) * Double.pi / 180
        let deltaLon = (coord2.longitude - coord1.longitude) * Double.pi / 180
        
        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
                cos(coord1.latitude * Double.pi / 180) * cos(coord2.latitude * Double.pi / 180) *
                sin(deltaLon / 2) * sin(deltaLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return earthRadius * c
    }

//    func horizontalHalfWidthInMeters(atLatitude latitude: CLLocationDegrees, heading: CLLocationDegrees) -> CLLocationDistance {
//        
//        /*
//        let earthRadius = 6371000.0 // Earth's radius in meters
//         let deltaLongitudeRadians = longitudeDelta * Double.pi / 180
//         let deltaLatitudeRadians = latitudeDelta * Double.pi / 180
//         
//         // Convert latitude to radians
//         let latitudeRadians = latitude * Double.pi / 180
//         let headingRadians = heading * Double.pi / 180
//         
//         // Calculate distances in meters
//         let widthLongitude = earthRadius * deltaLongitudeRadians * cos(latitudeRadians)
//         let widthLatitude = earthRadius * deltaLatitudeRadians
//         
//         // Adjust for the heading
//         let adjustedWidth = sqrt(pow(widthLongitude * cos(headingRadians), 2) + pow(widthLatitude * sin(headingRadians), 2))
//         
//        return adjustedWidth/2.0
//         */
//         let earthRadius = 6371000.0 // Earth's radius in meters
//          let deltaLongitudeRadians = longitudeDelta * Double.pi / 180
//          let deltaLatitudeRadians = latitudeDelta * Double.pi / 180
//          
//          // Convert latitude to radians
//          let latitudeRadians = latitude * Double.pi / 180
//          let headingRadians = heading * Double.pi / 180
//          
//          // Calculate width in meters for both latitude and longitude deltas
//          let widthLongitude = earthRadius * deltaLongitudeRadians * cos(latitudeRadians)
//          let widthLatitude = earthRadius * deltaLatitudeRadians
//          
//          // Combine the effects of both width and heading
//          let adjustedWidth = sqrt(pow(widthLongitude * cos(headingRadians), 2) + pow(widthLatitude * sin(headingRadians), 2))
//          
//        return adjustedWidth/2.0
//     }
}

