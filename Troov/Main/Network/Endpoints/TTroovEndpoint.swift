//
//  TTroovEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.05.23.
//

import Foundation

enum TTroovEndpoint {
    case troov(id: String)
    case create(troov: Troov)
    case update(troov: Troov)
    case recommended(filters: DiscoverFilterSettings)
    case confirmed
    case open
    case match(troovId: String)
    case requestToJoinTroov(troovId: String, chat: Chat)
    case allMatch
    case confirm(troovId: String, userId: String)
    case cancelTroov(troovId: String, userId: String)
    case cancelJoinRequest(troovId: String, userId: String)
    case declineJoinRequest(troovId: String, userId: String)

    case delete(troovId: String)
}

extension TTroovEndpoint: TEndpoint {
    var name: String? {
        return "troov"
    }
    
    var description: String? {
        return "Operations for managing troovs"
    }
    
    var path: String {
        switch self {
        case .troov(let id):
            return "/v1/troov/\(id)"
        case .create:
            return "/v1/troov/create"
        case .update(let troov):
            return "/v1/troov/\(troov.troovId!)"
        case .recommended:
            return "/v1/discover/troovs/\(userId)"
        case .confirmed:
            return "/v1/troov/status/confirmedAndPendingReview/\(userId)"
        case .open:
            return "/v1/troov/createdBy/\(userId)/status/open"
        case .match(let troovId):
            return "/v1/troov/\(troovId)/matchRequests"
        case .requestToJoinTroov(let troovId, _):
            return "/v1/troov/\(troovId)/requestToJoinTroov/\(userId)"
        case .allMatch:
            return "/v1/troov/getTroovsWithPendingJoinRequestsForUser/\(userId)"
        case .confirm(let troovId, let userId):
            return "/v1/troov/\(troovId)/confirm/\(userId)"
        case .cancelTroov(let troovId, let userId):
            return "/v1/troov/\(troovId)/cancelTroovForUser/\(userId)"
        case .cancelJoinRequest(let troovId, let userId):
            return "/v1/troov/\(troovId)/cancelJoinRequestForUser/\(userId)"
        case .declineJoinRequest(let troovId, let userId):
            return "/v1/troov/\(troovId)/declineJoinRequestFromUser/\(userId)"
        case .delete(let troovId):
            return "/v1/troov/delete/\(troovId)"
        }
    }

    var method: THTTPMethod? {
        switch self {
        case .create, .recommended:
            return .post
        case .confirmed, .open, .match, .allMatch, .troov:
            return .get
        case .requestToJoinTroov, .confirm, .cancelTroov, .cancelJoinRequest, .declineJoinRequest, .update:
            return .put
        case .delete:
            return .delete
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
        case .create(let troov),
             .update(let troov):
            return .json(troov)
        case .recommended(let filters):
            return .json(filters)
        case .requestToJoinTroov(_, let chat):
            return .json(chat)
        default:
            return nil
        }
    }
}
