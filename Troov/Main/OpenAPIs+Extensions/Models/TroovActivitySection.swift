//
//  TroovActivitySection.swift
//  Troov
//
//  Created by Levon Arakelyan on 17.11.23.
//

import Foundation

struct TroovActivitySection: Identifiable {
    var activities: [TroovActivity]
    let title: String
    
    public var id: String { title }
    
    var isSearching: Bool { title == "Search Results" }
}
