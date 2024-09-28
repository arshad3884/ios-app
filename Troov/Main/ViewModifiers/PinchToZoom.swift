//
//  PinchToZoom.swift
//  PinchToZoom
//
//  Created by Leo on 10.09.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

/**PinchToZoom ViewModifier**/

struct PinchToZoom: ViewModifier {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .center
    @State private var offset: CGSize = .zero
    @State private var isPinching: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .offset(offset)
            .animation(isPinching ? .none : .spring(), value: isPinching)
            .overlay(PinchZoom(scale: $scale,
                               anchor: $anchor,
                               offset: $offset,
                               isPinching: $isPinching))
    }
}
