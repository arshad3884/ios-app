//
//  TPrimaryLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.09.23.
//

import SwiftUI

struct TPrimaryLabel: View {
    var leadingImage: Image?
    let text: String
    var trailingImage: Image?
    var height: CGFloat = 56.0
    var style: Style = .affirmative
    var isLoading: Bool = false
    var font = UIFont.poppins700(size: 18)

    private var foregroundColor: Color {
        style == .affirmative ? .white : .primaryTroovRed
    }
    
    private var backgroundColor: Color {
        style == .affirmative ? .primaryTroovColor : .primaryTroovRed.opacity(0.1)
    }

    var body: some View {
        HStack(spacing: 0) {
            if let image = leadingImage {
                image
                    .padding(.trailing, 10)
            }
            Text(text)
                .fontWithLineHeight(font: font,
                                    lineHeight: font.pointSize)
            if let image = trailingImage {
                image
                    .padding(.leading, 10)
            }
            if isLoading {
                ProgressView().progressViewStyle(.circular)
                    .padding(.leading, 5)
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .foregroundStyle(foregroundColor)
        .background(content: {
            Capsule().fill(backgroundColor)
        })
    }
}

struct TPrimaryLabel_Previews: PreviewProvider {
    static var previews: some View {
        TPrimaryLabel(text: "Primary")
    }
}

extension TPrimaryLabel {
    enum Style {
        case destructive
        case affirmative
    }
}
