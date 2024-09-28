//
//  MaterialLabel.swift
//  Troov
//
//  Created by Levon Arakelyan on 28.09.23.
//

import SwiftUI

struct MaterialLabel: View {
    var name: String
    var age: String?
    var height: String?
    var image: String?
    var cornerRadius: CGFloat = 12
    var font: UIFont = .poppins600(size: 12)
    var lineHeight: CGFloat = 12
    var verticalPadding: CGFloat = 6
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center,
                   spacing: 0) {
                HStack(alignment: .firstTextBaseline,
                       spacing: age != nil ? 3 : 0) {
                    Text("\(name)\(age != nil ? "," : "")")
                        .fontWithLineHeight(font: font, lineHeight: lineHeight)
                    if let age = age {
                        Text(age)
                            .fontWithLineHeight(font: .poppins600(size: 15), lineHeight: 15)
                        
                    }
                }
                if let height = height {
                    Spacer()
                    HStack(alignment: .center,
                           spacing: 3, content: {
                        Image("t.height")
                        Text(height)
                            .fontWithLineHeight(font: .poppins400(size: 13), lineHeight: 13)
                    })
                }
                if let image = image {
                    Image(image)
                        .padding(.leading, 10)
                }
            }
                   .frame(maxWidth: .infinity)
                   .foregroundColor(.white)
                   .padding(.vertical, verticalPadding)
                   .padding(.horizontal, 8.5)
        }
         .background(RoundedRectangle(cornerRadius: cornerRadius).fill(.ultraThinMaterial))
         .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: 0.5)
                .stroke(.white, lineWidth: 1)
        )
    }
}

#Preview {
    MaterialLabel(name: "Angie",
                       age: "25",
                       height: "6’1”")
}
