//
//  ActivityFilterItem.swift
//  Troov
//
//  Created by  Levon Arakelyan on 20.09.2023.
//

import Foundation

enum ActivityFilterItem: String, CaseIterable {
    case location
    case distance
    case availability
    case cost
    
    var filterMenuName: String {
        switch self {
        case .location: return "Location"
        case .distance: return "Distance"
        case .availability: return "Availability"
        case .cost: return "Cost"
        }
    }
    
    var info: String? {
        switch self {
        case .location: return "None"
        case .distance: return "None"
        case .availability: return "None"
        case .cost: return nil
        }
    }
}
