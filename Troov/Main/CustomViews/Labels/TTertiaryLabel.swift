//
//  TTertiaryLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.09.23.
//

import SwiftUI

struct TTertiaryLabel: View {
    var image: String?
    let text: String
    var isSelected: Bool = false
    var height: CGFloat = 56.0
    var fontSize: CGFloat = 18
    var remove: (() -> (Void))? = nil

    var body: some View {
        HStack(alignment: .center,
               spacing: 0) {
            if let image = image {
                Image(image)
                    .renderingMode(.template)
                    .padding(.trailing, remove != nil ? 3 : 10)
            }
            Text(text)
                .fontWithLineHeight(font: .poppins400(size: fontSize), lineHeight: fontSize)
                .minimumScaleFactor(0.01)
                .fixedSize(horizontal: false, vertical: true)
            if let remove = remove {
                Button(action: remove) {
                    Image("t.xmark")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 11,
                               height: 11)
                        .foregroundColor(.primaryTroovColor)
                }.buttonStyle(.scalable)
                 .padding(.leading, 5)
            }
        }
        .foregroundColor(isSelected ? Color.primaryTroovColor : .rgba(34, 34, 34, 1))
        .padding(.horizontal, 15.relative(to: .width))
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(Capsule().fill(isSelected ? Color.rgba(236, 236, 255, 1) : Color.white))
        .overlay(
            Capsule()
                .stroke(isSelected ? .primaryTroovColor : Color.black.opacity(0.1), lineWidth: 1))
    }
}

struct TTertiaryLabel_Previews: PreviewProvider {
    static var previews: some View {
        TTertiaryLabel(image: "t.checkmark",
                       text: "Tertiary",
                       isSelected: true)
    }
}
