//
//  AdminChatSessionCellView.swift
//  Troov
//
//  Created by Levon Arakelyan on 05.11.23.
//

import SwiftUI

struct AdminChatSessionCellView: View {
    var session: AdminChatSession

    private var title: String {
        session.adminProfile?.firstName ?? ""
    }

    private var state: ChatSession.State {
        session.state
    }

    var body: some View {
            HStack(alignment: .center,
                   spacing: 0) {
                ActiveChannelImageView(images: session.element1.adminServerImages,
                                       state: state)
                .padding(.trailing, 16)
                VStack(alignment: .leading, spacing: 7) {
                    Text(title)
                        .lineLimit(1)
                        .fontWithLineHeight(font: .poppins700(size: 14), lineHeight: 14)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.rgba(34, 34, 34, 1))
                    HStack(alignment: .center,
                           spacing: 0) {
                        if state == .unread {
                            Image("chat.checkmark.blue")
                                .padding(.trailing, 6)
                        }
                        Text(session.element2.sessionContent)
                            .fontWithLineHeight(font: state == .unread ? .poppins700(size: 12) : .poppins400(size: 12), lineHeight: 12)
                            .foregroundColor(.rgba(34, 34, 34, 1))
                            .lineLimit(1)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 20) {
                    Text(session.createdAt ?? .now, style: .time)
                        .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.rgba(22, 37, 52, 0.2))
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white.cornerRadius(15))
    }
}

#Preview {
    AdminChatSessionCellView(session: .init(.init(state: .unread,
                                                  adminProfile: .init(),
                                                  adminId: ""),
                                            .init()))
}
