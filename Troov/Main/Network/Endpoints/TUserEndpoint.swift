//
//  TUserEndpoint.swift
//  Troov
//
//  Created by Leo on 23.01.23.
//

import Foundation

enum TUserEndpoint {
    case create(user: User)
    case user(userId: String? = nil)
    case profile(id: String)
    case info(token: String)
    case update(userProfile: UserProfile)
    case userProfile(userId: String)
    case updateUserAccount(user: User)
}

extension TUserEndpoint: TEndpoint {
    var name: String? {
        return "user"
    }
    
    var description: String? {
        return "Operations for managing all user-related information"
    }
    
    var path: String {
        switch self {
        case .create:
            return "/v1/user/"
        case .user(let userId):
            return "/v1/user/\(userId ?? self.userId)"
        case .update:
            return "/v1/user/profile/\(userId)"
        case .updateUserAccount:
            return "/v1/user/\(userId)"
        case .userProfile(let userId):
            return "/v1/user/profile/\(userId)"
        default:
            return ""
        }
    }

    var method: THTTPMethod? {
        switch self {
        case .create:
            return .post
        case .profile, .user, .userProfile, .info:
            return .get
        case .update, .updateUserAccount:
            return .put
        }
    }

    var header: [String: String]? {
        get async {
            return [
                "Authorization": "Bearer \(await token)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: TEndpointBody? {
        switch self {
        case .create(let user):
            return .json(user)
        case .update(let userProfile):
            return .json(userProfile)
        case .updateUserAccount(let user):
            return .json(user)
        default:
            return nil
        }
    }
}
