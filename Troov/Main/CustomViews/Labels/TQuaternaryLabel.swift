//
//  TQuaternaryLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 18.09.23.
//

import SwiftUI

struct TQuaternaryLabel: View {
    let text: String
    var image: String?
    var foregroundColor: Color = .textFieldForeground
    var triggerAttention: Bool = false
    var ceaseAnimation: Bool = false

    var body: some View {
        HStack(alignment: .center,
               spacing: 0) {
            Text(text)
                .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 21)
                .foregroundColor(foregroundColor)
            Spacer()
            if let image = image {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.textFieldForeground)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 56.0)
        .frame(maxWidth: .infinity)
        .overlay(content: {
            Capsule().stroke(Color.overlayGray, lineWidth: 1)
        }).softAttentionAnimation(triggerAttention: triggerAttention,
                                  ceaseAnimation: ceaseAnimation,
                                  background: .capsule)
    }
}

struct TQuaternaryLabel_Previews: PreviewProvider {
    static var previews: some View {
        TQuaternaryLabel(text: "Quaternary",
                         image: "t.calendar")
    }
}
