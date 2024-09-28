//
//  TActivityIdea.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.11.23.
//

import Foundation

typealias TActivityIdeas = [String]

struct TActivityIdea: Codable, Identifiable {
    var id: String {
        return text
    }
    var text: String
}
