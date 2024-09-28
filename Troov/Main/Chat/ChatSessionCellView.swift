//
//  ChatSessionCellView.swift
//  Troov
//
//  Created by  Levon Arakelyan on 13.09.2023.
//

import SwiftUI

struct ChatSessionCellView: View {
    let session: EChatSession
    let edit: ((EChatSession) -> Void)
    let select: ((Troov) -> Void)

    private var state: ChatSession.State {
        session.state
    }

    private var troov: Troov {
        session.element1.troov
    }

    private var title: String {
        session.title ?? ""
    }

    var body: some View {
            HStack(alignment: .center,
                   spacing: 0) {
                ActiveChannelImageView(images: session.images,
                                       state: state)
                .padding(.trailing, 16)
                VStack(alignment: .leading, spacing: 7) {
                    Text(title)
                        .lineLimit(1)
                        .fontWithLineHeight(font: .poppins700(size: 14), lineHeight: 14)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.rgba(34, 34, 34, 1))
                    Button(action: selectTroov) {
                        TinyBorderedLabel(text: troov.title)
                            .lineLimit(1)
                    }.buttonStyle(.scalable)
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
                    Text(session.lastUpdatedAt?.getHourFromDate ?? "")
                        .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
                        .foregroundStyle(Color.rgba(22, 37, 52, 0.2))
                    Button(action: { edit(session) },
                           label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(.rgba(34, 34, 34, 0.6))
                    }).buttonStyle(.scalable)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white.cornerRadius(15))
    }

    private func selectTroov() {
        select(troov)
    }
}

struct ChatSessionCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChatSessionCellView(session: .init(.init(state: .unread,
                                                 troov: .preview), .init())) {_ in } select: {_ in}
    }
}
