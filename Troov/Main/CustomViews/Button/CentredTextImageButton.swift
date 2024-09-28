//
//  CentredTextImageButton.swift
//  mango
//
//  Created by Leo on 19.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct CentredTextImageButton: View {
    var imageName: String
    var title: String

    var body: some View {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primaryTroovColor)
                    .frame(height: 51)
                HStack {
                    Image(imageName)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                    Text(title)
                        .foregroundColor(.white)
                        .fontWithLineHeight(font: .poppins500(size: 16),
                                            lineHeight: 20)
                }
            }
    }
}

struct CentredTextImageButton_Previews: PreviewProvider {
    static var previews: some View {
        CentredTextImageButton(imageName: "t.location",
                               title: "Find Dates Near Me")
    }
}
