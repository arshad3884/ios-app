//
//  PickSectionHeaderView.swift
//  mango
//
//  Created by Leo on 19.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct PickSectionHeaderView: View {
    var imageName: String
    var title: String

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .fontWithLineHeight(font: .poppins500(size: 14),
                                    lineHeight: 21)
        }.frame(height: 42)
         .frame(maxWidth: .infinity)
         .background(RoundedRectangle(cornerRadius: 5)
            .fill(Color.primaryTroovColor))
    }
}

struct PickSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PickSectionHeaderView(imageName: "t.calendar",
                              title: "Mon, 22 jun" + " \u{00B7} " + "Today")
    }
}
