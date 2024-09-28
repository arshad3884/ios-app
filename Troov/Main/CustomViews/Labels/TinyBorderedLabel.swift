//
//  TinyBorderedLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 02.11.23.
//

import SwiftUI

struct TinyBorderedLabel: View {
    var text: String

    var body: some View {
        HStack(alignment: .center,
               spacing: 8.5) {
            Image("t.light.bulb")
            Text(text)
                .foregroundStyle(Color.rgba(34, 34, 34, 1))
                .fontWithLineHeight(font: .poppins500(size: 10), lineHeight: 15)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .background(Color(red: 0.24, green: 0.29, blue: 0.85)
            .opacity(0.05))
        .cornerRadius(7)
        .overlay(
          RoundedRectangle(cornerRadius: 7)
            .inset(by: 0.5)
            .stroke(Color.primaryTroovColor, lineWidth: 1)
        )
    }
}

#Preview {
    TinyBorderedLabel(text: "Troov 1")
}
