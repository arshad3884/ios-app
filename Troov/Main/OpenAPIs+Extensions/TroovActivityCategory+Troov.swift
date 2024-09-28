//
//  TroovActivityCategory+Troov.swift
//  Troov
//
//  Created by Levon Arakelyan on 25.09.24.
//

import Foundation

extension TroovActivityCategory {
    var title: String {
        switch self {
        case .other:
            return "Custom"
        default:
            return rawValue.cleanEnums
        }
    }
}
