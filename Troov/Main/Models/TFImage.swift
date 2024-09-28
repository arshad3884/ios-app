//
//  TFImage.swift
//  mango
//
//  Created by Leo on 16.11.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import SwiftUI

struct TFImage: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var url: String
    var image: Image
    var uiImage: UIImage?
    var rank: Int?
}

extension TFImage {
    static let scale: CGFloat = 6/5
    static let reverseScale: CGFloat = 5/6
    static let smallSize = 50.0
}
