//
//  Extension+TroovCoreDetailFilterAttributesMaximumDistance.swift
//  Troov
//
//  Created by Levon Arakelyan on 24.10.23.
//

import Foundation

extension TroovCoreDetailFilterAttributesMaximumDistance {
    static let allowedLocalMax: Int = 3000
    static let `default`: Int = 25
    static let allowedSliderMax: Int = 101

    var distanceText: String? {
        if let length = length,
           let unit = unit {
            if length >= Double(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax) {
                return "\(TroovCoreDetailFilterAttributesMaximumDistance.allowedSliderMax - 1)+ \(unit.rawValue.lowercased())\(length > 1 ? "s" : "")"
            }
            
            let convertedDouble = length.round(to: 1)
            
            if convertedDouble.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(convertedDouble)) \(unit.rawValue.lowercased())\(length > 1 ? "s" : "")"
            } else {
                return "\(convertedDouble) \(unit.rawValue.lowercased())\(length > 1 ? "s" : "")"
            }
        } else {
            return nil
        }
    }
}
