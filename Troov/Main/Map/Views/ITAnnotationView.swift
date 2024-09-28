//
//  ITAnnotationView.swift
//  Troov
//
//  Created by Leo on 25.03.23.
//

import SwiftUI

struct ITAnnotationView: View {
    var isSelected: Bool

    private var image: String {
        isSelected ? "t.map.location.selected" : "t.map.location"
    }

    var body: some View {
        VStack(spacing: -13) {
            Image("t.map.tags")
                .renderingMode(.template)
                .offset(y: isSelected ? -4 : 0)
                .animation(.spring(), value: isSelected)
            ZStack {
                Image("t.map.ellipse.big")
                    .renderingMode(.template)
                Image("t.map.ellipse.small")
                    .renderingMode(.template)
            }
        }.foregroundColor(.primaryTroovColor)
    }
}

struct ITAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ITAnnotationView(isSelected: false)
    }
}
