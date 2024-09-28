//
//  MessageTextField.swift
//  mango
//
//  Created by Leo on 26.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct MessageTextField: View {
    @Binding var text: String
    @FocusState private var isTextFieldFocused: Bool

    let send: () -> ()
    let textFiledIsFocused: (Bool) -> ()
    
    private let mainColor = Color.rgba(233, 235, 237, 1)
    
    var body: some View {
        HStack(alignment: .bottom,
               spacing: 8) {
            HStack(alignment: .center,
                   spacing: 8) {
                /* Future usage
                Button(action: {}, label: {
                    Image("t.smile")
                        .padding(2)
                        .background(mainColor)
                }).buttonStyle(.scalable(value: 0.9))
                 */
                TextField("Type your message",
                          text: $text, axis: .vertical)
                    .lineLimit(1...5)
                    .foregroundColor(.primaryBlack)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 3)
                    .padding(8)
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) { _, newValue in
                        textFiledIsFocused(newValue)
                    }
                /* Future usage
                Button(action: {}, label: {
                    Image("t.chat.camera")
                        .padding(2)
                        .background(mainColor)
                }).padding(.horizontal, 10)
                    .buttonStyle(.scalable(value: 0.9))
                Button(action: {}, label: {
                    Image("t.chat.voice")
                        .padding(2)
                        .background(mainColor)
                }).buttonStyle(.scalable(value: 0.9))
                 */
            }
             .background(RoundedRectangle(cornerRadius: 20)
                .fill(mainColor))
//            .frame(height: 40)
            Button(action: send,
                   label: {
                Image("t.arrow.right")
                    .padding(6)
                    .background(Circle()
                        .fill(text.isClean ? Color.rgba(167, 175, 184, 1) : Color.primaryTroovColor))
            }).buttonStyle(.scalable(value: 0.9))
        }
    }
}

struct MessageTextField_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextField(text: .constant("")) {} textFiledIsFocused: {_ in}
    }
}
