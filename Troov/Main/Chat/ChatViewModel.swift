//
//  ChatViewModel.swift
//  mango
//
//  Created by Leo on 29.10.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import SwiftUI

@Observable class ChatViewModel {
    private let chatService = TChatService()
    private let troovService = TTroovService()
    private let userService = TUserService()

    private(set) var sessions: [EChatSession] = []
    private(set) var currentSession: EChatSession?
    private(set) var adminChatSession: AdminChatSession?
    
    private var userId: String {
        chatService.userId ?? ""
    }
    
    private var createdByFirstName: String {
        ProfileViewModel.shared.user?.firstName ?? ""
    }

    var currentSessionMessages: [EChat] {
        var messages: [EChat] = []
        if let items = currentSession?.messages {
            items.forEach { chat in
                messages.append(EChat(.init(owner: chat.owner(by: userId)), chat))
            }
        }
        
        return messages
    }
    
    var adminMessages: [EChat] {
        var messages: [EChat] = []
        if let items = adminChatSession?.messages {
            
            items.forEach { chat in
                messages.append(EChat(.init(owner: chat.owner(by: userId)), chat))
            }
        }
        
        return messages
    }
    
    func send(message: String,
              sessionId: String) {
        Task {
            let now = Date.now
            let chat = Chat(id: UUID().uuidString,
                            createdAt: now,
                            createdByUserId: userId,
                            createdByFirstName: createdByFirstName,
                            messageContent: message)
            await append(chat: chat, sessionId: sessionId)
            let _ = await chatService.addChat(sessiondId: sessionId,
                                              message: chat)
        }
    }
    
    func sendAdmin(message: String,
                   sessionId: String) {
        Task {
            let now = Date.now
            let chat = Chat(id: UUID().uuidString,
                            createdAt: now,
                            createdByUserId: userId,
                            createdByFirstName: createdByFirstName,
                            messageContent: message)
            await MainActor.run {
                adminChatSession?.messages?.append(chat)
                adminChatSession?.lastUpdatedAt = .now
            }
            let _ = await chatService.addChat(sessiondId: sessionId,
                                              message: chat)
        }
    }
        
    private func append(chat: Chat, sessionId: String) async {
        await MainActor.run(body: {
            currentSession?.messages?.append(chat)
            if let index = sessions.firstIndex(where: {$0.id == sessionId}) {
                sessions[index].lastUpdatedAt = .now
                sessions[index].messages?.append(chat)
            }
        })
    }
    
    private func append(session: ChatSession,
                        troov: Troov) async {
        let state = session.sessionLastMessageViewedByState(userId: userId)
        var images: [TServerImage]?
        var title: String?
        if let participantProfile = session
            .participantProfiles?
            .filter({$0.userId != userService.userId}).first {
            images = participantProfile.images
            title = participantProfile.firstName
        } 

        let eSession: EChatSession = .init(.init(state: state,
                                                 troov: troov,
                                                 images: images,
                                                 title: title),
                                           session)
        if let index = sessions.firstIndex(where: {$0.id == session.id}) {
            await MainActor.run(body: {
                sessions[index] = eSession
            })
        } else {
            await MainActor.run(body: {
                sessions.insert(eSession, at: 0)
            })
        }
    
       await MainActor.run(body: {
           if eSession.id == currentSession?.id {
               select(session: eSession)
           }
       })
    }

    private func assignAdminChatSession(_ session: ChatSession) {
        if let adminId = session.participantUserIds?.first(where: {$0 != userId}) {
            Task {
                var adminProfile = ProfileViewModel.shared.adminUserProfile
                /**Prevent from multiple admin profile fetches**/
                if adminProfile == nil, case .success(let adminUserProfile) = await self.userService.userProfile(adminId) {
                    ProfileViewModel.shared.adminUserProfile = adminUserProfile
                    adminProfile = adminUserProfile
                }
                
                let state = session.sessionLastMessageViewedByState(userId: userId)

                let adminChatSession = AdminChatSession(.init(state: state,
                                                              adminProfile: adminProfile,
                                                              adminId: adminId),
                                                        session)
                await MainActor.run {
                    self.adminChatSession = adminChatSession
                }
            }
        }
    }
    
    private func update(eSession: EChatSession) async {
        if let index = sessions.firstIndex(where: {$0.id == eSession.id}) {
            await MainActor.run(body: {
                sessions[index] = eSession
            })
        } else {
            await MainActor.run(body: {
                sessions.insert(eSession, at: 0)
            })
        }
    }

    @MainActor func select(session: EChatSession?) {
        currentSession = session
    }
    
    @MainActor func selectSession(for troov: Troov) -> String? {
        if let session = sessions.first(where: {$0.troovId == troov.troovId}) {
            currentSession = session
            return session.id
        } else {
            return nil
        }
    }

   @MainActor func delete(_ session: EChatSession) {
        if let index = sessions.firstIndex(where: {$0.id == session.id}) {
            sessions.remove(at: index)
        }
    }
    
    func fetchSessions(confirmedTroovs: [Troov],
                       myTroovs: [Troov],
                       theirTroovs:  [Troov]) async {
        let result = await chatService.activeSessions()
        switch result {
        case .success(let sessions):
            receivedChatSessions(sessions: sessions,
                                 confirmedTroovs: confirmedTroovs,
                                 myTroovs: myTroovs,
                                 theirTroovs: theirTroovs)
        case .failure(let failure):
            debugPrint("=====>>> receivedChatSessions from fetchSessions error: \(failure)")
        }
    }
    
    func resetUIContent(resetCurrentSession: Bool) async {
        await MainActor.run {
            if resetCurrentSession {
                self.select(session: nil)
            }
        }
    }
    
    /**
     Received chat session from notification
     */
    private func receivedChatSessions(sessions: [ChatSession],
                                      confirmedTroovs: [Troov],
                                      myTroovs: [Troov],
                                      theirTroovs:  [Troov]) {
        let userId = userId
        
        let filteredArray = self.sessions.filter { item in
            return sessions.contains(where: {$0.id == item.id})
        }

        self.sessions = filteredArray
        
        Task {
            for session in sessions {
                if let requesterId = session.requesterId {
                    let ownOpening = session.status == .openingRequest && requesterId == userId
                    guard !ownOpening else { return }
                }
                if session.isAdminChatSession == true {
                    assignAdminChatSession(session)
                } else if let troovId = session.troovId {
                    if let troov = confirmedTroovs.first(where: {$0.troovId == troovId}) {
                        await self.append(session: session, troov: troov)
                    } else if let troov = myTroovs.first(where: {$0.troovId == troovId}) {
                        await self.append(session: session, troov: troov)
                    } else if let troov = theirTroovs.first(where: {$0.troovId == troovId}) {
                        await self.append(session: session, troov: troov)
                    } else if case .success(let troov) = await troovService.troov(by: troovId) {
                        await self.append(session: session, troov: troov)
                    }
                }
            }
        }
    }

    func confirm(troovId: String,
                 session: EChatSession) {
        if let participantId = session.participantUserIds?.first(where: {$0 != userId}) {
            if let index = sessions.firstIndex(where: {$0.id == session.id}) {
                sessions[index].troov.status = .confirmed
                currentSession?.troov.status = .confirmed
            }
            Task { await troovService.confirm(troovId: troovId, userId: participantId) }
        }
    }
    
    func openChatSession(troov: Troov, match: TroovMatchRequest) {
        Task {
            guard let troovId = troov.troovId else { return }
            if let session = sessions.first(where: {$0.id == match.chatSessionId}) {
                await MainActor.run {
                    self.select(session: session)
                }
            } else if let userId = match.requester?.userId,
                      let session = sessions.first(where: {$0.participantUserIds?.contains(userId) == true && troovId == $0.troovId}) {
                await MainActor.run {
                    self.select(session: session)
                }
            } else if let chatSessionId = match.chatSessionId,
                      case .success(let chatSession) = await chatService.session(id: chatSessionId) {
                await MainActor.run {
                    let newSession: EChatSession = .init(.init(state: .unread,
                                                               troov: troov,
                                                               images: match.requester?.images,
                                                               title: match.requester?.firstName),
                                                         chatSession)
                    self.select(session: newSession)
                }
            } else if let chatSession = ChatSession.openSession(troovId: troovId,
                                                                userId: userId,
                                                                match: match) {
                await MainActor.run {
                    let newSession: EChatSession = .init(.init(state: .unread,
                                                               troov: troov,
                                                               images: match.requester?.images,
                                                               title: match.requester?.firstName),
                                                         chatSession)
                    self.select(session: newSession)
                }
            }
        }
    }

    func cancel(session: EChatSession) {
        Task {
            guard let troovId = session.troov.troovId else { return }
            guard let sessionId = session.element2.id else { return }

            if session.troov.isOwn, let requesterId = session.element2.participantUserIds?.first(where: {$0 != userId}) {
                await troovService.cancelJoinRequest(troovId: troovId, userId: requesterId)
            } else {
                await troovService.cancelJoinRequest(troovId: troovId, userId: userId)
            }
            
            await chatService.delete(sessionId: sessionId)
            await delete(session)
        }
    }

    func confirm(session: EChatSession) {
        Task {
            guard let troovId = session.troov.troovId else { return }
            guard let requesterId = session.element2.participantUserIds?.first(where: {$0 != userId}) else { return }
            await troovService.confirm(troovId: troovId, userId: requesterId)
        }
    }

    func sessionViewedBy(sessionId: String) {
        if let index = sessions.firstIndex(where: {$0.element2.id == sessionId}) {
            sessions[index].state = .read
        } else if adminChatSession?.element2.id == sessionId {
            adminChatSession?.state = .read
        }
        Task {
            await chatService.sessionViewedBy(sessionId: sessionId)
        }
    }
}
