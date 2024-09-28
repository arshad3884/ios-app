//
//  CircleFillLabel.swift
//  mango
//
//  Created by Leo on 25.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct CircleFillLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
            .foregroundColor(.white)
            .padding(6)
            .background(Circle()
                .fill(Color.primaryTroovColor))
            .overlay { Circle().stroke(Color.white, lineWidth: 2)}
    }
}

struct CircleFillLabel_Previews: PreviewProvider {
    static var previews: some View {
        CircleFillLabel(text: "1")
    }
}
