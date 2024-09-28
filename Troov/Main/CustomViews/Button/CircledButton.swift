//
//  CircledButton.swift
//  mango
//
//  Created by Leo on 19.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct CircledButton: View {
    var imageName: String
    var imageColor: Color
    var color: Color
    var size: CGFloat
    var imageSize: CGFloat
    var shadowOpacity: Double = 0.2
    var action: () -> ()

    var body: some View {
        Button(action: action,
               label: {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: size,
                           height: size)
                Image(imageName)
                    .resizable()
                    .frame(width: imageSize,
                           height: imageSize)
                    .foregroundColor(imageColor)
            }.shadow(color: Color.primaryBlack.opacity(shadowOpacity),
                     radius: 10,
                     x: 0,
                     y: 0)
        })
    }
}

struct CircledButton_Previews: PreviewProvider {
    static var previews: some View {
        CircledButton(imageName: "t.xmark",
                      imageColor: .primaryTroovRed,
                      color: .white,
                      size: 34,
                      imageSize: 10.29) {}
    }
}
