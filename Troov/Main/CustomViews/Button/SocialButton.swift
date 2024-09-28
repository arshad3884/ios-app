//
//  SocialButton.swift
//  mango
//
//  Created by Leo on 05.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct SocialButton: View {
    var image: String
    var name: String
    var color: Color = .white
    var foregroundColor: Color = .black
    private let height: CGFloat = 60

    var body: some View {
        ZStack(alignment: .leading) {
            color.cornerRadius(16)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30,
                       height: 30)
                .padding(.leading, 20)
            GeometryReader { proxy in
                Text(name)
                    .fontWithLineHeight(font: .poppins500(size: 16),
                                        lineHeight: 24)
                    .foregroundColor(foregroundColor)
                    .frame(width: proxy.size.width,
                           height: height,
                           alignment: .center)
            }
        }.frame(height: height)
         .padding(.horizontal, 20)
    }
}

struct SocialButton_Previews: PreviewProvider {
    static var previews: some View {
        SocialButton(image: "t.google",
                     name: "Login with Google")
    }
}
