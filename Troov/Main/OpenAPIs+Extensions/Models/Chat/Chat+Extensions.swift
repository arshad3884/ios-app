//
//  Chat+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 24.08.23.
//

import Foundation

extension Chat {
    func owner(by userId: String?) -> TChat.Owner {
        return userId == createdByUserId ? .own : .other
    }
}
