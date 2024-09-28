//
//  FailableDecodable.swift
//  Troov
//
//  Created by Levon Arakelyan on 23.01.24.
//

import Foundation

struct FailableDecodable<Base : Decodable> : Decodable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
