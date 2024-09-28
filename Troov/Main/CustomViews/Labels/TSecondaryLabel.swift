//
//  TSecondaryLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.09.23.
//

import SwiftUI

struct TSecondaryLabel: View {
    var text: String
    var height: CGFloat = 56.0
    var isFilled = false

    var body: some View {
        Text(text)
         .fontWithLineHeight(font: .poppins700(size: 18), lineHeight: 18)
        .foregroundColor(.primaryTroovColor)
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(Capsule().fill(isFilled ? Color.rgba(236, 236, 255, 1) : .white))
        .overlay(
            Capsule()
                .stroke(Color.primaryTroovColor, lineWidth: 2))
    }
}

struct TSecondaryLabel_Previews: PreviewProvider {
    static var previews: some View {
        TSecondaryLabel(text: "Secondary")
    }
}
