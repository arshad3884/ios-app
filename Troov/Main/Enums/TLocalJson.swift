//
//  TLocalJson.swift
//  Troov
//
//  Created by Leo on 23.01.23.
//

import Foundation

enum TLocalJson: String {
    case userProfile = "user-user_id"
    case discoverTroovs = "discover-troovs-user_id"
    case confirmedTroovs = "troov-status-CONFIRMED-user_id"
    case myTroovs = "troov-createdby-user_id-status-PENDING"
    case theirTroovs = "troov-matchRequests-requester-user_id-status-PENDING"
    case activityIdeas = "t.activity.ideas"
}

extension TLocalJson {
    var filename: String {
        return self.rawValue
    }
}
