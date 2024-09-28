//
//  BottomBarButton.swift
//  mango
//
//  Created by Leo on 24.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct BottomBarButton: View {
    var title: String
    @Binding var action: Bool
    var body: some View {
        ZStack(alignment: .center) {
               Color.white
                    .frame(height: .bottomBarHeight)
                    .shadow(color: Color.black.opacity(0.1),
                            radius: 3, x: 0, y: -5)
            Button(action: {
                self.action.toggle()
            }, label: {
                ZStack {
                    Color.primaryTroovColor
                         .frame(height: 40.0)
                         .cornerRadius(8)
                    Text(title)
                        .fontWithLineHeight(font: .poppins500(size: 15),
                                            lineHeight: 22.5)
                        .foregroundColor(.white)
                }
          }).padding(.horizontal, 20)

        }
    }
}

struct BottomBarButton_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarButton(title: "Go to confirm dates",
                        action: .constant(false))
    }
}
