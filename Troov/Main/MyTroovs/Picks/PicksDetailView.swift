//
//  PicksDetailView.swift
//  mango
//
//  Created by Leo on 18.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct PicksDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(MyTroovsViewModel.self) var myTroovsViewModel
    @Environment(ChatViewModel.self) var chatViewModel
    @Environment(TRouter.self) var router

    @State private var rejectMatchWarning = false

    private var currentPick: Troov? {
        myTroovsViewModel.currentMyPick
    }
    
    private var matches: [TroovMatchRequest] {
        return currentPick?.pendingMatchRequests ?? []
    }
    
    var body: some View {
        @Bindable var router = router
        VStack(spacing: 0) {
            PrimaryTopToolbarView(title: "My Picks",
                                  action: { dismiss() })
            .frame(height: 112)
            ScrollView(showsIndicators: false) {
                ForEach(matches, id: \.requester?.userId) { match in
                    PickDetailCell(match: match,
                                   viewRequest: { match in viewRequest(match) },
                                   decline: { decline($0) },
                                   accept: {  match in selectMatch(match: match) },
                                   reply: { match in reply(match: match) })
                    .padding(.vertical, 12)
                }
            }.padding(.horizontal, 14)
            Spacer()
        }.ignoresSafeArea(edges: .all)
            .background(Color.rgba(232, 235, 241, 1))
            .overlay(content: {
                if rejectMatchWarning {
                    ClassicPopover(title: "Remove this request?",
                                   approveTitle: "Yes",
                                   resignTitle: "No",
                                   height: 150,
                                   acceptancePriority: .low,
                                   showPicker: $rejectMatchWarning) { myTroovsViewModel.declineMatch() }
                }
            })
            .sheet(item: $router.picksDetailViewSheetPath, content: { path in
                switch path {
                case .troovRequestView(let troov):
                    NavigationStack {
                        TroovRequestView(troov: troov)
                    }
                case .troovAcceptDialogueView(let item):
                    TroovRequestView.AcceptDialogueView(accept: acceptTroovRequest,
                                                        item: item)
                case .chat:
                    NavigationStack {
                        ChatView()
                    }
                }
            })
    }
    
    @MainActor private func viewRequest(_ match: TroovMatchRequest) {
        if let troov = currentPick {
            myTroovsViewModel.select(match: match)
            router.sheetPicksDetailView(.troovRequestView(troov: troov))
        }
    }
    
    @MainActor private func decline(_ match: TroovMatchRequest) {
        myTroovsViewModel.select(match: match)

        withAnimation {
            rejectMatchWarning.toggle()
        }
    }
    
    @MainActor private func selectMatch(match: TroovMatchRequest) {
        myTroovsViewModel.select(match: match)
        let item = TroovRequestView.AcceptDialogueView.Item(images: myTroovsViewModel.currentTroovMatchRequest?.requester?.images ?? [],
                                                            name: currentPick?.createdBy?.firstName ?? "Unknown",
                                                            startTime: currentPick?.startTime)
        router.sheetPicksDetailView(.troovAcceptDialogueView(item: item))
    }

    @MainActor private func reply(match: TroovMatchRequest) {
        myTroovsViewModel.select(match: match)
        if let troov = currentPick,
           let match = myTroovsViewModel.currentTroovMatchRequest {
            chatViewModel.openChatSession(troov: troov,
                                          match: match)
            router.sheetPicksDetailView(.chat)
        }
    }
    
    private func acceptTroovRequest() {
        Task { await myTroovsViewModel.confirmCurrentMatchRequest() }
    }
}

struct PicksDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PicksDetailView()
    }
}
