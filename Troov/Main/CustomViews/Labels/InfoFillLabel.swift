//
//  InfoFillLabel.swift
//  mango
//
//  Created by Leo on 15.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct InfoFillLabel: View {
    let text: String
    var body: some View {
        HStack(alignment: .center,
               spacing: 10) {
            Image("info.icon")
                .resizable()
                .frame(width: 22.relative(to: .width),
                       height: 22.relative(to: .width))
            Text(text)
                .lineLimit(5)
                .fontWithLineHeight(font: .poppins400(size: 12),
                                    lineHeight: 18)
                .foregroundColor(.primaryTroovColor)
                .multilineTextAlignment(.leading)
            Spacer()
        }.padding(17)
         .background(RoundedRectangle(cornerRadius: 15)
            .fill(Color.primaryTroovColor.opacity(0.08)))
    }
}

struct InfoFillLabel_Previews: PreviewProvider {
    static var previews: some View {
        InfoFillLabel(text: "There are no Pick for you Yet.")
    }
}
