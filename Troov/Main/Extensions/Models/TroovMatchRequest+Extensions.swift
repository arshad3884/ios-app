//
//  TroovMatchRequest+Extensions.swift
//  Troov
//
//  Created by Leo on 01.05.23.
//

import Foundation


extension TroovMatchRequest: Identifiable {
    public var id: String { self.troovId! }
}
