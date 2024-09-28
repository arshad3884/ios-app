//
//  ClassicNavigationBar.swift
//  mango
//
//  Created by Leo on 04.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ClassicNavigationBar: View {
    @Environment(\.dismiss) private var dismiss
    
    var title: String
    var withShadow: Bool = true
    @Binding var shouldDisappear: Bool?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.white.shadow(radius: withShadow ? 10 : 0)
            HStack {
                Button(action: backButtonAction) {
                    ZStack {
                        Color.white
                        Image("t.arrow.narrow.left")
                            .foregroundColor(.primaryBlack)
                    }.frame(width: 30,
                            height: 30)
                }
                Text(title)
                    .fontWithLineHeight(font: .poppins500(size: 26),
                                        lineHeight: 28)
                    .foregroundColor(.primaryNavigationBarBlackColor)
            }
            .padding(.bottom, 16)
            .padding(.leading, 24)
        }.frame(height: .navigationBarHeight)
            .zIndex(1)
    }

    private func backButtonAction() {
        shouldDisappear = true
        dismiss()
    }
}

struct ClassicNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ClassicNavigationBar(title: "Discover",
                             shouldDisappear: .constant(nil))
    }
}
