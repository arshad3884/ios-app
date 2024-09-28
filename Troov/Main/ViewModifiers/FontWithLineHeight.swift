//
//  FontWithLineHeight.swift
//  mango
//
//  Created by Leo on 22.01.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    private var height: CGFloat {
        (lineHeight - font.lineHeight)//.relative(to: .height)
    }

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(height)
            .padding(.vertical, height / 2.0)
    }
}
