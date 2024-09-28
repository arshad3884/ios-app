//
//  SoftBackground.swift
//  Troov
//
//  Created by Levon Arakelyan on 17.11.23.
//

import SwiftUI

struct SoftBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(Color.primaryTroovColor.opacity(0.06)))
    }
}

extension ViewModifier where Self == SoftBackground {
    static var softBackground: SoftBackground { .init() }
}

extension View {
    var softBackground: some View {
        self.modifier(SoftBackground.softBackground)
    }
}
