//
//  RoundedTextView.swift
//  mango
//
//  Created by Leo on 08.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct RoundedTextView: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: self.$text)
                .fontWithLineHeight(font: .poppins400(size: 14),
                                    lineHeight: 20)
                .foregroundColor(.primaryBlack)
                .background(Color.primaryTroovLightGray)
                .cornerRadius(4.0)
            if text.isEmpty {
                Text(placeholder)
                    .fontWithLineHeight(font: .poppins400(size: 14),
                                        lineHeight: 20)
                    .foregroundColor(Color.primaryBlack.opacity(0.4))
                    .padding(.leading, 8)
                    .padding(.top, 10)
            }
        }
    }

    init(placeholder: String,
         text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }
}

struct RoundedTextView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTextView(placeholder: "Description *",
                        text: .constant(""))
    }
}
