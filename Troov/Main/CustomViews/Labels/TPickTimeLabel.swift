//
//  TPickTimeLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 29.09.23.
//

import SwiftUI

struct TPickTimeLabel: View {
    let isCritical: Bool
    let text: String

    private let primaryTroovRed = Color.primaryTroovRed

    private var imageColor: Color {
        isCritical ? primaryTroovRed : .rgba(34, 34, 34, 1)
    }

    private var textColor: Color {
        isCritical ? primaryTroovRed : .rgba(34, 34, 34, 1)
    }

    private var strokeColor: Color {
        isCritical ? primaryTroovRed : .rgba(248, 149, 0, 1)
    }
    
    var body: some View {
        HStack(alignment: .center,
               spacing: 5,
               content: {
            Image("t.clockwise")
                .renderingMode(.template)
                .foregroundStyle(imageColor)
            Text(text)
                .fontWithLineHeight(font: .poppins500(size: 10), lineHeight: 15)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
        }).padding(.vertical, 4.5)
          .padding(.horizontal, 13)
          .background {
             RoundedRectangle(cornerRadius: 7)
                 .fill(strokeColor.opacity(0.1))
         }
    }
}

#Preview {
    TPickTimeLabel(isCritical: true,
                   text: "18 mins left")
}
