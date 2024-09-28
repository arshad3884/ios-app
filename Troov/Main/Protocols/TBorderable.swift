//
//  TBorderable.swift
//  Troov
//
//  Created by Levon Arakelyan on 06.07.23.
//

import SwiftUI

protocol TBorderable {}

extension TBorderable {
    var backgroundCornered: some View {
        borderlessBackgroundCornered
             .overlay(border)
    }

    var borderlessBackgroundCornered: some View {
        Color.white
             .cornerRadius(8)
    }

    
    func borderlessBackgroundCornered(color: Color,
                                      cornerRadius: CGFloat = 12) -> some View {
        color
             .cornerRadius(cornerRadius)
    }

    var border: some View {
        RoundedRectangle(cornerRadius: 8)
            .inset(by: 0.5)
            .stroke(Color.rgba(189, 193, 198, 1), lineWidth: 1)
    }

    func border(radius: Double) -> some View {
        RoundedRectangle(cornerRadius: radius)
            .inset(by: 0.5)
            .stroke(Color.rgba(189, 193, 198, 1), lineWidth: 1)
    }
}
