//
//  LocationIndicator+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 02.05.24.
//

import SwiftUI
import CoreLocation

extension LocationIndicator {
    var pin: String {
        if hidden {
           return "t.location.indicator.pin.hidden"
        } else {
            return "t.location.indicator.pin"
        }
    }
    
    var mapPin: String {
        if hidden {
           return "t.location.indicator.pin.hidden.key"
        } else {
            return "t.location.fill"
        }
    }

    var pinView: some View {
        Image(pin)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16,
                   height: 17)
    }

    var placeName: String {
        if hidden {
            if let distance = distanceFromSearchLocation?.length {
                return "\(formatMeters(distance)) away"
            } else {
                return "X miles away"
            }
        } else {
            return location?.name ?? "Unknown"
        }
    }

    /**
     Format hidden distance miles
     */
    private func formatMeters(_ meters: Double) -> String {
        let metersPerMile = 1609.34

        // Calculate the number of full miles
        let miles = Int((meters / metersPerMile).rounded())
        if miles > 100 {
            return "100+ miles"
        } else {
            if miles == 1 {
                return "1 mile"
            } else if miles < 1 {
                let remainingMeters = Int((meters.truncatingRemainder(dividingBy: metersPerMile)).rounded())
                if remainingMeters == 1 {
                    return "1 meter"
                } else {
                    return "\(remainingMeters) meters"
                }
            } else {
                return "\(miles) miles"
            }
        }
    }
}
