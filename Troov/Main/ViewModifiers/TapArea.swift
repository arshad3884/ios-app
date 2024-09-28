//
//  TapArea.swift
//  Troov
//
//  Created by Levon Arakelyan on 17.07.24.
//

import SwiftUI

struct TapArea: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.vertical, .trailing], 10)
            .background(Color.white)
    }
}

struct TapAreaCircled: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.primaryTroovColor)
            .padding(12)
            .background {
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 2)
            }
    }
}

extension ViewModifier where Self == TapArea {
    static var enlargeTapAreaForTopLeadingButton: TapArea { .init() }
}

extension ViewModifier where Self == TapAreaCircled {
    static var enlargeTapAreaCircledButton: TapAreaCircled { .init() }
}

extension View {
    var enlargeTapAreaForTopLeadingButton: some View {
        self.modifier(TapArea.enlargeTapAreaForTopLeadingButton)
    }
    
    var enlargeTapAreaCircledButton: some View {
        self.modifier(TapAreaCircled.enlargeTapAreaCircledButton)
    }
}

