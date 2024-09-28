//
//  SearchTag.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.01.24.
//

import Foundation

struct SearchTag: Codable, Hashable {
    var tagName: String
    var count: Int?
}

extension SearchTag: Identifiable {
    var id: UUID {
       return UUID()
    }
}
