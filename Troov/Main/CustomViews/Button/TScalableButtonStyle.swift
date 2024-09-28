//
//  TScalableButtonStyle.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.09.23.
//

import SwiftUI

struct TScalableButtonStyle: ButtonStyle {
    var scale: Double = 0.93
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
    }
}

extension ButtonStyle where Self == TScalableButtonStyle {
    static var scalable: TScalableButtonStyle { .init() }
    static func scalable(value: Double) -> TScalableButtonStyle { .init(scale: value) }
}
