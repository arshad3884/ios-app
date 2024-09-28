//
//  RoundedShape.swift
//  mango
//
//  Created by Leo on 11.02.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI
import Foundation

struct RoundedShape: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
