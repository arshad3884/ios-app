//
//  RegistrationTextFieldView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct RegistrationTextFieldView: View, KeyboardReadable {
    @FocusState private var isFocused: Bool

    @Binding var text: String
    let prompt: String
    var trailingPadding = 0.0
    var triggerAttention: Bool = false
    var ceaseAnimation: Bool = false
    
    var body: some View {
        HStack {
            TextField("", text: $text,
                      prompt: Text("\(prompt)")
                .foregroundStyle(Color(hex: "A7AFB8")),
                      axis: .vertical)
            .focused($isFocused)
            .keyboardType(.asciiCapable)
            .lineLimit(3)
            .foregroundStyle(Color.textFieldForeground)
            .padding(.horizontal, 20.relative(to: .width))
            .padding(.trailing, trailingPadding)
            .padding(.vertical, 2)
        }
        .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 14)
        .frame(minHeight: 56)
        .overlay(content: {
            Capsule().stroke(isFocused ? .primaryTroovColor : Color.overlayGray, lineWidth: 1)
        }).softAttentionAnimation(triggerAttention: triggerAttention,
                                  ceaseAnimation: isFocused || ceaseAnimation,
                                  background: .capsule)

    }
}

struct RegistrationTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationTextFieldView(text: .constant(""),
                                  prompt: "")
    }
}
