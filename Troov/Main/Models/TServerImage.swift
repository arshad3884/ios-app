//
//  TServerImage.swift
//  mango
//
//  Created by Leo on 18.06.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import Foundation

struct TServerImage: Equatable {
    var id: String = UUID().uuidString
    var userId: String
    var url: String?
    var rank: Int?

    static var preview: TServerImage {
        TServerImage(userId: "", rank: 0)
    }

    static var empty: TServerImage {
        TServerImage(userId: "", rank: 0)
    }
}
