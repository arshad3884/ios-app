//
//  TCapsuleLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 10.02.24.
//

import SwiftUI

struct TCapsuleLabel: View {
    var text: String?
    var imageName: String?
    var imageWidth: CGFloat = 21
    var fill: Color = .primaryTroovColor

    var body: some View {
        HStack(spacing: 0) {
            if let text = text {
                Text(text)
                    .fontWithLineHeight(font: .poppins500(size: 12),
                                        lineHeight: 18)
                    .padding(.trailing, imageName != nil ? 8 : 0)
            }
            
            if let imageName = imageName {
                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageWidth)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.white)
        .padding(.vertical, 11)
        .background(Capsule().fill(fill))
    }
}

#Preview {
    TCapsuleLabel(text: "Accept",
                  imageName: "t.chat.sign")
}
