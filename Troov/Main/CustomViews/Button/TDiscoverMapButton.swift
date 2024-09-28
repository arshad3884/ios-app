//
//  TDiscoverMapButton.swift
//  Troov
//
//  Created by Leo on 24.02.23.
//

import SwiftUI

struct TDiscoverMapButton: View {
    let icon: String
    
    static let size: CGFloat = 61
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            Image(icon)
                .renderingMode(.template)
                .foregroundStyle(Color.primaryTroovColor)
        }.frame(width: Self.size, height: Self.size)
    }
}

struct TDiscoverMapButton_Previews: PreviewProvider {
    static var previews: some View {
        TDiscoverMapButton(icon: "t.map")
    }
}
