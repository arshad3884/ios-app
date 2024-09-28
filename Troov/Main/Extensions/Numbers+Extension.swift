//
//  Numbers+Extension.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.09.23.
//

import UIKit

extension CGFloat {
    static var tabBarHeight: CGFloat {
        UIApplication.shared.keyWindowBounds.height/8
    }
    static let discoverSheetCompactHeight: CGFloat = 180
    static let navigationBarHeight: CGFloat = 80//120
    static let bottomBarHeight: CGFloat = 94
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    static let figmaRelativeW: CGFloat = UIScreen.main.bounds.width / 375.0
    static let figmaRelativeH: CGFloat = UIScreen.main.bounds.height / 812.0

    func between(a: CGFloat, b: CGFloat) -> Bool {
        return self >= Swift.min(a, b) && self <= Swift.max(a, b)
    }

    func relative(to figma: FigmaSize) -> CGFloat {
        switch figma {
        case .width:
            return self * CGFloat.figmaRelativeW
        case .height:
            return self * CGFloat.figmaRelativeH
        }
    }
}

extension Double {
    func relative(to figma: FigmaSize) -> Double {
        switch figma {
        case .width:
            return self * CGFloat.figmaRelativeW
        case .height:
            return self * CGFloat.figmaRelativeH
        }
    }

    func round(to decimalPlaces: Int) -> Double {
        let factor = pow(10.0, Double(decimalPlaces))
        let roundedLatitude = (self * factor).rounded() / factor
        return roundedLatitude
    }
}

extension Int {
    func relative(to figma: FigmaSize) -> CGFloat {
        switch figma {
        case .width:
            return CGFloat(self) * CGFloat.figmaRelativeW
        case .height:
            return CGFloat(self) * CGFloat.figmaRelativeH
        }
    }
}

enum FigmaSize {
    case width
    case height
}
