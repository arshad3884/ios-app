//
//  SelectableTroov.swift
//  Troov
//
//  Created by Levon Arakelyan on 05.01.24.
//

import Foundation

typealias ExtendedTroov = Compose<TroovExtension, Troov>

struct TroovExtension {
    var isExpanded: Bool
    var isOwn: Bool
}

extension ExtendedTroov {
    init(troov: Troov?,
         isExpanded: Bool,
         isOwn: Bool) {
        if let troov = troov {
            self.init(.init(isExpanded: isExpanded,
                            isOwn: isOwn), troov)
        } else {
            fatalError("Troov not found")
        }
    }
}
