//
//  TabBarIcon.swift
//  mango
//
//  Created by Leo on 17.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct TabBarIcon: View {
    let currentRoute: TTabRoute
    let route: TTabRoute

    let width, height: CGFloat

    private var color: Color {
        return route == currentRoute ? Color.primaryTroovColor : Color.primaryBlack.opacity(0.8)
    }

    private var icon: String {
        currentRoute.icon
    }
    
    var body: some View {
            VStack(spacing: 0) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.top, 26)
                    .padding(.bottom, 4.2)
                Spacer()
            }.frame(width: width)
             .padding(.horizontal, -4)
             .foregroundStyle(color)
        }
}

struct TabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabBarIcon(currentRoute: .discover(.List),
                   route: .discover(.Map),
                   width: 24,
                   height: 24)
    }
}
