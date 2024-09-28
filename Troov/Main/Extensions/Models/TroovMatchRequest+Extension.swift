//
//  TroovMatchRequest+Extension.swift
//  Troov
//
//  Created by Leo on 04.04.23.
//

import Foundation

extension TroovMatchRequest {
    init() {
        self.status = .confirmed
        self.requester = UserProfileWithUserId(userId: "empty_user_id")
        self.requestedAt = .now
        self.statusUpdatedAt = .now
        self.lastStatus = ""
        self.troovId = UUID().uuidString
    }
}
