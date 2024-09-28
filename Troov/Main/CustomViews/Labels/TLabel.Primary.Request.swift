//
//  Label.Primary.Request.swift
//  Troov
//
//  Created by Levon Arakelyan on 08.08.24.
//

import SwiftUI

extension TLabel.Primary {
    struct Request: View {
        private let title: String
        private let image: String

        var body: some View {
            HStack(spacing: 6) {
                Text(title)
                    .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
                Image(image)
                    .renderingMode(.template)
            }
             .foregroundStyle(Color.white)
             .padding(.vertical, 11)
             .padding(.horizontal, 24)
             .background {
                 RoundedRectangle(cornerRadius: 10)
                     .fill(LinearGradient(colors: [Color(hex: "4E5CEC"),
                                                   Color(hex: "#1D2CC6")],
                                          startPoint: .top,
                                          endPoint: .bottom))
             }
        }

        init(title: String = "Request",
             image: String = "t.chat.sign.21x12") {
            self.title = title
            self.image = image
        }
    }
}

#Preview {
    TLabel.Primary.Request()
}
