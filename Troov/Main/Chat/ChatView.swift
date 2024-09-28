//
//  ChatView.swift
//  mango
//
//  Created by Leo on 25.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ChatView: View, KeyboardReadable {
    @Environment(\.dismiss) private var dismiss
    @Environment(ChatViewModel.self) var chatViewModel

    private var session: EChatSession? {
        chatViewModel.currentSession
    }

    private var messages: [EChat] {
        chatViewModel.currentSessionMessages
    }

    @State private var message: String = ""
    @Namespace private var bottomID
    @State private var scrollToBottom = false
    @State private var isBottomVisible: Bool = false

    @State private var confirmed = false

    private var troov: Troov? {
        session?.element1.troov
    }

    private var needsConfirmation: Bool {
        !confirmed
    }

    private var sessionImage: TServerImage? {
        return session?.images?.first
    }

    private var sessionTitle: String? {
        return session?.title
    }

    private var isOwn: Bool {
        troov?.isOwn == true
    }

    var body: some View {
        VStack(spacing: 0) {
            MessageNavigationView(troov: troov,
                                  image: sessionImage,
                                  title: sessionTitle)
            if needsConfirmation {
                ConfirmChatView(confirm: confirmAction,
                                cancel: cancel,
                                isPending: !isOwn)
                Rectangle()
                    .fill(Color.rgba(247, 247, 247, 1))
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
            }
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(messages, id: \.id) { chat in
                            ChatCell(chat: chat)
                        }
                    }.padding(.horizontal, 16)
                     .padding(.top, needsConfirmation ? 14 : 5)
                    
                    Color.white
                        .frame(height: 5)
                        .id(bottomID)
                        .background(
                            GeometryReader { geometry in
                                Color.clear.preference(key: ViewVisibilityKey.self,
                                                       value: isViewVisible(geometry: geometry))
                            }
                        )
                        .onPreferenceChange(ViewVisibilityKey.self) { isVisible in
                            isBottomVisible = isVisible
                        }
                        .onChange(of: scrollToBottom) { _, _ in
                            withAnimation() {
                                proxy.scrollTo(bottomID)
                            }
                        }.onChange(of: session?.messages?.count) { _, _ in
                            withAnimation() {
                                proxy.scrollTo(bottomID)
                            }
                        }
                }.layoutPriority(1)
            }
            VStack(spacing: 0) {
                MessageTextField(text: $message,
                                 send: send,
                                 textFiledIsFocused: textFiledIsFocused)
                    .frame(maxWidth: .infinity)
                    .padding(7)
            }.background(Color.white)
             .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4)
        }
         .background(Color.white)
         .navigationBarBackButtonHidden()
         .toolbar(content: {
             keyboardToolbar
         })
         .onAppear(perform: appear)
         .onDisappear(perform: dissappear)
    }

    private func isViewVisible(geometry: GeometryProxy) -> Bool {
        let minY = geometry.frame(in: .global).minY
        let maxY = geometry.frame(in: .global).maxY
        let screenHeight = UIScreen.main.bounds.height
        return minY >= 0 && maxY <= screenHeight
    }
    
    private func textFiledIsFocused(_ newValue: Bool) {
        if newValue && isBottomVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                scrollToBottom.toggle()
            })
        }
    }

    private func send() {
        guard let sessionId = session?.id else { return }
        chatViewModel.send(message: message,
                           sessionId: sessionId)
        DispatchQueue.main.async {
            message = ""
            endEditing()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            scrollToBottom.toggle()
        })
    }

    private func confirmAction() {
        withAnimation {
            confirmed = true
        }
    
        if let session = session {
            chatViewModel.confirm(session: session)
        }
    }

    private func cancel() {
        if let session = session {
            dismiss()
            chatViewModel.cancel(session: session)
        }
    }

    private func appear() {
        confirmed = troov?.status == .confirmed
        scrollToBottom.toggle()
        guard let sessionId = session?.element2.id else { return }
        chatViewModel.sessionViewedBy(sessionId: sessionId)
    }

    private func dissappear() {
        guard let sessionId = session?.element2.id else { return }
        chatViewModel.sessionViewedBy(sessionId: sessionId)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
