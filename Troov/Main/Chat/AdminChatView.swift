//
//  AdminChatView.swift
//  Troov
//
//  Created by Levon Arakelyan on 05.11.23.
//

import SwiftUI

struct AdminChatView: View, KeyboardReadable {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(ChatViewModel.self) var chatViewModel
    
    private var session: AdminChatSession? {
        chatViewModel.adminChatSession
    }
    
    private var messages: [EChat] {
        chatViewModel.adminMessages
    }
    
    @State private var message: String = ""
    @Namespace private var bottomID
    @State private var scrollToBottom = false
    @State private var isBottomVisible: Bool = false

    private var sessionImage: TServerImage? {
        return session?.element1.adminServerImages.first
    }
    
    private var sessionTitle: String? {
        return session?.adminProfile?.firstName
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MessageNavigationView(troov: nil,
                                  image: sessionImage,
                                  title: sessionTitle)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(messages, id: \.id) { chat in
                            ChatCell(chat: chat)
                        }
                    }.padding(.horizontal, 16)
                        .padding(.top, 5)
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
                        .onChange(of: scrollToBottom, { _, _ in
                            withAnimation() {
                                proxy.scrollTo(bottomID)
                            }
                        })
                        .onChange(of: session?.messages?.count) { _, _ in
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
                .padding(7)
                .frame(maxWidth: .infinity)
            }.background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4)
        }.background(Color.white)
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
        chatViewModel.sendAdmin(message: message,
                                sessionId: sessionId)
        DispatchQueue.main.async {
            message = ""
            endEditing()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            scrollToBottom.toggle()
        })
    }
    
    private func appear() {
        scrollToBottom.toggle()
        guard let sessionId = session?.element2.id else { return }
        chatViewModel.sessionViewedBy(sessionId: sessionId)
    }
    
    private func dissappear() {
        guard let sessionId = session?.element2.id else { return }
        chatViewModel.sessionViewedBy(sessionId: sessionId)
    }
}

#Preview {
    AdminChatView()
}
