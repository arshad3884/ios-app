//
//  PrimitiveNavigationBar.swift
//  mango
//
//  Created by Leo on 05.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct PrimitiveNavigationBar: View {
    var title: String
    var withShadow: Bool = true
    
    var body: some View {
        HStack {
            Text(title)
                .fontWithLineHeight(font: .poppins600(size: 18),
                                    lineHeight: 21)
                .foregroundColor(.primaryTroovColor)
                .padding(.bottom, 22.relative(to: .height))
                .padding(.leading, 16.relative(to: .height))
            Spacer()
        }
            .frame(height: .navigationBarHeight,
                   alignment: .bottomLeading)
            .frame(maxWidth: .infinity)
            .zIndex(1)
            .overlay(alignment: .bottom) {
                Color.rgba(247, 247, 247, 1)
                    .frame(height: 2)
            }
    }
}

struct PrimitiveNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        PrimitiveNavigationBar(title: "Date filters")
    }
}
