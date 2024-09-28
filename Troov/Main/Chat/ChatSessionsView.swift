//
//  ChatSessionsView.swift
//  mango
//
//  Created by Leo on 25.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ChatSessionsView: View {
    @AppStorage("t.chatsession.status") private var status = TroovStatus.confirmed
    @Environment(TRouter.self) var router: TRouter

    @Environment(ChatViewModel.self) var chatViewModel
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel
    @State private var onOffsetChange = false
    
    private var sessions: [EChatSession] {
        chatViewModel
            .sessions
            .filter({$0.troov.status == status})
            .sorted(by: { session1, session2 in
                if let lastUpdatedAt1 = session1.lastUpdatedAt,
                   let lastUpdatedAt2 = session2.lastUpdatedAt {
                    return lastUpdatedAt1 > lastUpdatedAt2
                }
                return false
            })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PrimitiveNavigationBar(title: "Chat")
                .zIndex(1)
                .overlay(alignment: .bottomTrailing) {
                    Button(action: search) {
                        Image("t.search")
                            .renderingMode(.template)
                            .foregroundColor(.primaryTroovColor)
                    }
                    .padding(.bottom, 20.relative(to: .height))
                    .padding(.trailing, 16.relative(to: .height))
                }
            SegmentedControlView(segments: status.segments,
                                 currentSegment: status.segment,
                                 select: select(_:))
            .padding(.vertical, 13)
            .padding(.horizontal, 16)
            Rectangle()
                .fill(Color.rgba(247, 247, 247, 1))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            TroovScrollView(axes: .vertical,
                            showsIndicators: false,
                            offsetChanged: { _ in onOffsetChange.toggle() }
            ) {
                VStack(spacing: 24) {
                    if let adminChatSession = chatViewModel.adminChatSession {
                        Button(action: { openAdminSupportAction() }) {
                            AdminChatSessionCellView(session: adminChatSession)
                        }
                        Divider()
                    }
                    ForEach(sessions, id: \.id) { session in
                        Button {
                            select(session: session)
                        } label: {
                            ChatSessionCellView(session: session,
                                                edit: edit(_:),
                                                select: { select($0) })
                                .modifier(TDeleteViewModifier(contentChange: onOffsetChange,
                                                              disable: false,
                                                              action: {
                                    delete(session)
                                }))
                        }
                        Divider()
                    }
                }
            }.refreshable(action: { 
                Task {
                    await chatViewModel.resetUIContent(resetCurrentSession: true)
                    await fetchChatSessions()
                }
            })
        }
    }

    @MainActor private func select(session: EChatSession) {
        chatViewModel.select(session: session)
        router.navigateTo(.chat(sessionId: session.id))
    }
    
    
    @MainActor private func openAdminSupportAction() {
        router.navigateTo(.adminChat(sessionId: chatViewModel.adminChatSession?.element2.id))
    }

    @MainActor private func delete(_ session: EChatSession) {
        chatViewModel.delete(session)
    }
    
    @MainActor private func select(_ troov: Troov) {
        router.navigateTo(.discover(troov: troov))
    }

    private func edit(_ session: EChatSession) {
    }

    private func search() {    }

    private func select(_ segment: SegmentedControlView.Segment) {
        if let status = TroovStatus(rawValue: segment.id) {
            self.status = status
        }
    }

    private func fetchChatSessions() async {
        let confirmedTroovs = myTroovsViewModel.confirmedTroovs
        let myTroovs = myTroovsViewModel.myTroovs
        let theirTroovs = myTroovsViewModel.theirTroovs

        await chatViewModel.fetchSessions(confirmedTroovs: confirmedTroovs,
                                          myTroovs: myTroovs,
                                          theirTroovs: theirTroovs)
        
    }
}

struct ChatSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSessionsView()
    }
}

extension ChatSessionsView {
    enum Status: String, CaseIterable {
        case confirmed = "Confirmed Troovs"
        case pending = "Pending Troovs"
    }
}

fileprivate extension TroovStatus {
    var segments: [SegmentedControlView.Segment] {
        return [TroovStatus.confirmed, TroovStatus._open].map({$0.segment})
    }

    var segment: SegmentedControlView.Segment {
        return .init(id: self.rawValue,
                     title: "\(self.rawValue.cleanEnums) Troovs")
    }
}
