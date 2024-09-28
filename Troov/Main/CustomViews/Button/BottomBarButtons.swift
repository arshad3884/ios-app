//
//  BottomBarButtons.swift
//  mango
//
//  Created by Leo on 23.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct BottomBarButtons: View {
    var disabled: Bool
    var negative: String
    var positive: String
    var negativeAction: () -> ()
    var positiveAction: () -> ()

    var body: some View {
            HStack(alignment: .center, spacing: 19) {
                Button(action: negativeAction,
                       label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(disabled ? Color.black.opacity(0.1) : .primaryBorder,
                                    lineWidth: 1)
                            .frame(height: 40.0)
                        Text(negative)
                            .fontWithLineHeight(font: .poppins400(size: 15), lineHeight: 15)
                            .foregroundColor(disabled ? .primaryDarkGray : .primaryTroovColor)
                    }
                })

                Button(action: positiveAction,
                       label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(disabled ? Color.primaryDarkGray : .primaryTroovColor)
                            .frame(height: 40.0)
                        Text(positive)
                            .fontWithLineHeight(font: .poppins500(size: 15), lineHeight: 15)
                            .foregroundColor(disabled ? Color.white.opacity(0.4) : .white)
                    }
                })
            }.padding(.horizontal, 16)
             .disabled(disabled)
    }
}

struct BottomBarButtons_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarButtons(disabled: true,
                         negative: "Reset",
                         positive: "Preview",
                         negativeAction: {},
                         positiveAction: {})
    }
}
