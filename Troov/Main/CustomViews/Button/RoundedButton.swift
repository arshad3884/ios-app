//
//  RoundedButton.swift
//  mango
//
//  Created by Leo on 17.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct RoundedButton: View {
    let image: String
    let imageColor: Color
    let fill: Color
    let size: CGSize
    let imageSize: CGSize
    var corner: CGFloat = 5
    
    var body: some View {
        Image(image)
            .resizable()
            .renderingMode(.template)
            .frame(width: imageSize.width,
                   height: imageSize.height)
            .aspectRatio(contentMode: .fit)
     
            .foregroundColor(imageColor)
            .frame(width: size.width,
                   height: size.height)
            .background(RoundedRectangle(cornerRadius: corner).fill(fill))
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(image: "t.xmark",
                      imageColor: .primaryTroovRed,
                      fill: .rgba(255, 26, 26, 0.1),
                      size: .init(width: 42,
                                  height: 34),
                      imageSize: .init(width: 13, height: 13))
    }
}
