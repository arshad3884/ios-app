//
//  TBackgroundProtocol.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.07.23.
//

import SwiftUI


protocol TBackgroundProtocol: TBorderProtocol { }

extension TBackgroundProtocol {
    var backgroundCornered: some View {
        borderlessBackgroundCornered
             .overlay(border)
    }

    var borderlessBackgroundCornered: some View {
        Color.white
             .cornerRadius(12)
             .shadow(color: .primaryTroovLightGray,
                    radius: 4, x: 0, y: 2)
    }

    
    func borderlessBackgroundCornered(color: Color,
                                      cornerRadius: CGFloat = 12) -> some View {
        color
             .cornerRadius(cornerRadius)
             .shadow(color: .primaryTroovLightGray,
                    radius: 4, x: 0, y: 2)
    }
}

protocol TBorderProtocol: View {}

extension TBorderProtocol {
    var border: some View {
        RoundedRectangle(cornerRadius: 12)
            .inset(by: 0.5)
            .stroke(Color.primaryTroovLightGray, lineWidth: 1)
    }

    func border(radius: Double) -> some View {
        RoundedRectangle(cornerRadius: radius)
            .inset(by: 0.5)
            .stroke(Color.primaryTroovLightGray, lineWidth: 1)
    }
}
