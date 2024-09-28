//
//  ProfileFilterAttributesMinHeight+Extension.swift
//  Troov
//
//  Created by Levon Arakelyan on 08.10.23.
//

import Foundation

extension ProfileFilterAttributesMinHeight {
    static func heightString(of value: Double) -> String {
        let roundedValue = round(value)
        if roundedValue == min {
            return "<5'0"
        } else if roundedValue == max {
            return ">6'5"
        }
        let intValue = Int(roundedValue)
        let inches = intValue % 12
        let feet = (intValue - inches)/12
        return "\(feet)'\(inches)"
    }

    static let min: Double = 59 // 4f 9 inch
    static let max: Double = 78 // 6f 6 inch
    static let medium: Double = 69 // 5f 9 inch
}

/** 'Statistics'
 min: 22 inches: max 107 inches
  1 foot == 12 inches
 max known - 8 feet 11.1
 min known - 21.5 inches
 */
