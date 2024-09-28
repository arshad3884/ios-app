//
//  TReversedGeoLocation.swift
//  Troov
//
//  Created by Leo on 07.02.23.
//

import SwiftUI
import MapKit

struct TReversedGeoLocation: Codable {
    let streetNumber: String?    // eg. 1
    let streetName: String?      // eg. Infinite Loop
    let city: String?            // eg. Cupertino
    let state: String?           // eg. CA
    let zipCode: String?         // eg. 95014
    let country: String?         // eg. United States
    let isoCountryCode: String?  // eg. US

    let areasOfInterest: [String]?
    
    var formattedAddress: String {
        var address = ""
        if let streetNumber = self.streetNumber,
           !streetNumber.isEmpty {
            address += streetNumber
        }
        if let streetName = self.streetName,
           !streetName.isEmpty {
            if !address.isEmpty {
                address += " "
            }
            address += streetName
        }
    
        if let city = self.city,
           !city.isEmpty {
            if !address.isEmpty {
                address += ",\n"
            }
            address += city
        }
    
        if let state = self.state,
           !state.isEmpty {
            if !address.isEmpty {
                address += ","
                address += " "
            }
            address += state
        }

        if let zipCode = self.zipCode,
           !zipCode.isEmpty {
            if !address.isEmpty {
                address += " "
            }
            address += zipCode
        }
    
        if let country = self.country,
           !country.isEmpty {
            if !address.isEmpty {
                address += "\n"
            }
            address += country
        }
        
        return address
    }

    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
        self.areasOfInterest = placemark.areasOfInterest
    }
    
    init(feature: MapFeature) {
        self.streetName     = feature.title ?? ""
        self.streetNumber   = ""
        self.city           = ""
        self.state          = ""
        self.zipCode        = ""
        self.country        = ""
        self.isoCountryCode = ""
        self.areasOfInterest = []
    }
}
