//
//  TPlaceholderable.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.05.23.
//

import SwiftUI

protocol TPlaceholderable {}

extension TPlaceholderable {
    var placeholder: some View {
        ZStack {
            Color.primaryTroovLightGray
            Image(systemName: "rectangle.stack.badge.person.crop")
                .foregroundColor(.primaryTroovColor)
        }
    }
}
