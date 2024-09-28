//
//  ChatSession+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 02.11.23.
//

import Foundation

extension ChatSession {
    var sessionContent: String {
        if let content = messages?.last?.messageContent {
            return String(content.prefix(50))
        }
        
        return ""
    }
    
    static func openSession(troovId: String,
                            userId: String,
                            match: TroovMatchRequest) -> ChatSession? {
        guard let requesterUserId = match.requester?.userId else { return nil}
        let openingChat = Chat(id: UUID().uuidString,
                               createdAt: match.requestedAt,
                               createdByUserId: match.requester?.userId,
                               messageContent: match.openingChatMessage)
        return ChatSession(id: UUID().uuidString,
                           status: .active,
                           troovId: troovId,
                           participantUserIds: [userId, requesterUserId],
                           messages: [openingChat],
                           mostRecentChatUserId: userId)
    }
    
    var requesterId: String? {
        if let participantUserIds = participantUserIds {
            return participantUserIds.first(where: {$0 != troovCreatorUserId})
        }
        return nil
    }
    
    func sessionLastMessageViewedByState(userId: String) -> State {
        if let lastMessage = messages?.last,
           lastMessage.createdByUserId != userId,
           let lastMessageCreationDate = lastMessage.createdAt {
            if let userViewedLastDate = lastViewedBy?.first(where: {$0.userId == userId})?.lastViewedAt {
                return userViewedLastDate > lastMessageCreationDate ? .read : .unread
            } else {
                return .unread
            }
        } else {
            return .read
        }
    }
}

extension ChatSession {
    enum State {
        case read
        case unread
    }
}
