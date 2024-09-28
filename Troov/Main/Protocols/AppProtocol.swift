//
//  AppProtocol.swift
//  Troov
//
//  Created by Levon Arakelyan on 08.10.23.
//

import UIKit

protocol AppProtocol {
    func hapticFeedback()
}

extension AppProtocol {
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
