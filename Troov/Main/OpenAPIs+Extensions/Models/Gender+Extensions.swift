//
//  Gender+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.10.23.
//

import Foundation

extension Gender {
    var image: String? {
        switch self {
        case .male:
            return "t.male"
        case .female:
            return "t.female"
        default:
            return nil
        }
    }
}
