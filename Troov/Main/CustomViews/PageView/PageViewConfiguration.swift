//
//  PageViewConfiguration.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.11.23.
//

import SwiftUI

struct PageViewConfiguration {
    var sliderInteritemSpacing: CGFloat
    var sliderEdgesHorizontalPadding: CGFloat = 10
    var vAlignment: VerticalAlignment
    var allowScalling: Bool = false
}

extension PageViewConfiguration {
    var sliderHorizontalEdgesVisibleSize: CGFloat {
        sliderInteritemSpacing + sliderEdgesHorizontalPadding
    }
}
