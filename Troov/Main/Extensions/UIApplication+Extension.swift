//
//  UIApplication+Extension.swift
//  mango
//
//  Created by Leo on 23.04.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }

    var KeyWindow: UIWindow? {
        self.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first
    }

    var keyWindowBounds: CGSize {
        KeyWindow?.bounds.size ?? .zero
    }
}
