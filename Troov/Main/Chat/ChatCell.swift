//
//  ChatCell.swift
//  mango
//
//  Created by Leo on 26.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ChatCell: View {
    let chat: EChat
    
    private var content: String {
        chat.messageContent ?? ""
    }
    
    private var backgroundColor: Color {
        chat.owner == .other ? .rgba(237, 237, 237, 1) : .primaryTroovColor
    }
    
    private var foregroundColor: Color {
        chat.owner == .other ? .rgba(34, 34, 34, 1) : .white
    }
    
    var body: some View {
        Button(action: chatBubbleAction,
               label: {
            HStack(alignment: .top,
                   spacing: 0) {
                if chat.owner == .own {
                    Spacer()
                }
                
                HStack(spacing: 14) {
                    if chat.owner == .own {
                        if let date = chat.createdAt {
                            Text(date.getHourFromDate)
                                .fontWithLineHeight(font: .poppins400(size: 14),
                                                    lineHeight: 14)
                                .foregroundColor(.rgba(169, 169, 169, 1))
                        }
                    }

                    Text(content)
                        .foregroundColor(foregroundColor)
                    /*
                        .multilineTextAlignment(chat.owner == .other ? .leading : .trailing)
                     */
                        .multilineTextAlignment(.leading)
                        .padding(chat.owner == .other ? .leading : .trailing, 20)
                        .padding(chat.owner == .other ? .trailing : .leading, 8)
                        .padding(.vertical, 15)
                        .background(backgroundColor)
                        .clipShape(BubbleShape(myMessage: chat.owner == .own ))
                    
                    if chat.owner == .other {
                        if let date = chat.createdAt {
                            Text(date.getHourFromDate)
                                .fontWithLineHeight(font: .poppins400(size: 14),
                                                    lineHeight: 14)
                                .foregroundColor(.rgba(169, 169, 169, 1))
                        }
                    }
                }
                if chat.owner == .other {
                    Spacer()
                }
            }
        })
    }
    
    private func chatBubbleAction() { }
}

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(chat: .init(.init(owner: .own),
                             .init()))
    }
}
