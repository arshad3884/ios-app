//
//  TChatEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.08.23.
//

import Foundation

enum TChatEndpoint {
    case session(id: String)
    case add(chat: Chat)
    case create(session: ChatSession)
    case activeSessions
    case addChat(sessionId: String, message: Chat)
    case delete(sessionId: String)
    case sessionViewedBy(sessionId: String)
}

extension TChatEndpoint: TEndpoint {
    var name: String? {
        return "chatSession"
    }
    
    var description: String? {
        return "Operations for managing conversations between users"
    }
    
    var path: String {
        switch self {
        case .session(let id):
            return "/v1/chatSession/\(id)"
        case .add(let chat):
            return "/v1/chatSession/\(chat.id!)"
        case .create:
            return "/v1/chatSession/create"
        case .activeSessions:
            return "/v1/chatSession/active/\(userId)"
        case .addChat(let sessionId, _):
            return "/v1/chatSession/\(sessionId)/addChat"
        case .delete(let sessionId):
            return "/v1/chatSession/delete/\(sessionId)"
        case .sessionViewedBy(let sessionId):
            return "/v1/chatSession/\(sessionId)/viewedBy/\(userId)"
        }
    }

    var method: THTTPMethod? {
        switch self {
        case .session, .activeSessions:
            return .get
        case .add, .create, .addChat:
            return .post
        case .sessionViewedBy:
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
        case .session, .activeSessions, .delete, .sessionViewedBy:
            return nil
        case .add(chat: let chat):
            return .json(chat)
        case .create(let session):
            return .json(session)
        case .addChat(_, let message):
            var chat = message
            chat.createdByUserId = userId
            return .json(chat)
        }
    }
}
