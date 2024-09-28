//
//  InfoLabel.swift
//  mango
//
//  Created by Leo on 25.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct InfoLabel: View {
    let text: String
    var lineLimit: Int = 3

    var body: some View {
        HStack(alignment: .center,
               spacing: 12) {
            Image("t.info")
                .resizable()
                .renderingMode(.template)
                .frame(width: 15,
                       height: 15)
                .foregroundStyle(Color.black)
            Text(text)
                .fontWithLineHeight(font: .poppins400(size: 12),
                                    lineHeight: 18)
                .foregroundStyle(Color.primaryTroovColor)
                .lineLimit(lineLimit)
                .fixedSize(horizontal: false,
                           vertical: true)
            Spacer()
        }
    }
}

struct InfoLabel_Previews: PreviewProvider {
    static var previews: some View {
        InfoLabel(text: "Your first image will appear in the date preview view.")
    }
}
