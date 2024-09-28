//
//  Crop.swift
//  Troov
//
//  Created by leo on 25.10.2023.
//

import SwiftUI

enum Crop: Equatable {
    case rectangle
    case circle
    case square
    case custom(CGRect)
    
    func name() -> String {
        switch self {
        case .rectangle:
            return "Rectangle"
        case .circle:
            return "Circle"
        case .square:
            return "Square"
        case let .custom(cCGRect):
            return "Custom \(Int(cCGRect.width))X\(Int(cCGRect.height))"
        }
    }
    
    func size() -> CGRect {
        switch self {
        case .rectangle:
            return CGRect(origin: .zero, size: .init(width: 400, height: 400*TFImage.scale))
                //if we use this case it should be corner radius in ImageView
        case .circle:
            return CGRect(origin: .zero, size: .init(width: 300, height: 300))
        case .square:
            return CGRect(origin: .zero, size: .init(width: 300, height: 300))
        case .custom(let cCGRect):
            return CGRect(origin: .zero, size: .init(width: cCGRect.width, height: cCGRect.height))
        }
    }
}
