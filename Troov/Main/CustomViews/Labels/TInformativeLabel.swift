//
//  TInformativeLabel.swift
//  Troov
//
//  Created by  Levon Arakelyan on 18.09.2023.
//

import SwiftUI

struct TInformativeLabel: View {
    let title: String
    let bodyText: String
    var inactive = true
    let erase: () -> ()
    var isCleanEnum = true
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title.cleanEnums)
             .fontWithLineHeight(font: .poppins700(size: 12), lineHeight: 12)
             .foregroundColor(.rgba(0, 13, 33, 1))
            Spacer()
            Text(cleanedBodyText)
                .foregroundColor(inactive ? .rgba(166, 174, 185, 1) : .primaryTroovColor)
                .fontWithLineHeight(font: .poppins500(size: 12), lineHeight: 12)
            if !inactive {
                Button(action: erase) {
                    EraseLabel()
                }.padding(.horizontal, 5)
            }
        }
        .background(Color.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }

    private var cleanedBodyText: String {
        if isCleanEnum {
            return bodyText.cleanEnums
        }
        return bodyText
    }
}

struct TInformativeLabel_Previews: PreviewProvider {
    static var previews: some View {
        TInformativeLabel(title: "",
                          bodyText: "",
                          erase: {})
    }
}
