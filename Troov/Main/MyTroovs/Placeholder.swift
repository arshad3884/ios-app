//
//  Placeholder.swift
//  Troov
//
//  Created by Levon Arakelyan on 11.10.23.
//

import SwiftUI

struct Placeholder: View {
    @Environment(TRouter.self) var router

    let headline: String
    var subHeadline: String?
    var hashtags: [String]?
    var leftButtonTitle: String = "Discover"
    var rightButtonTitle: String = "Create Troov"
    var fillColor: Color = Color.primaryTroovColor.opacity(0.06)
    var image: String? = "t.happy.light.bulb"
    var rightButtonAction: (() -> ())?
    var leftButtonAction: (() -> ())?
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            if let image = image {
                Image(image)
            }
            Text(headline)
                .fontWithLineHeight(font: .poppins500(size: 22), lineHeight: 33)
                .foregroundColor(.rgba(33, 33, 33, 1))
                .fixedSize(horizontal: false,
                           vertical: true)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            if let subHeadline = subHeadline {
                Text(subHeadline)
                    .fontWithLineHeight(font: .poppins500(size: 18), lineHeight: 27)
                    .foregroundColor(.rgba(33, 33, 33, 1))
                    .fixedSize(horizontal: false,
                               vertical: true)
                    .multilineTextAlignment(.center)
            }
            if let tags = hashtags {
                THashTagsView(tags: .constant(tags))
                    .disabled(true)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            HStack(alignment: .center,
                   spacing: 0) {
                if let leftButtonAction = leftButtonAction {
                    Button(action: leftButtonAction) {
                        TPrimaryLabel(text: leftButtonTitle)
                    }.buttonStyle(.scalable)
                        .padding(.trailing, 10)
                        .trackRUMTapAction(name: router.dataDogTapAction(named: leftButtonTitle))
                }
                if let rightButtonAction = rightButtonAction {
                    Button(action: rightButtonAction) {
                        TPrimaryLabel(text: rightButtonTitle)
                    }.buttonStyle(.scalable)
                        .trackRUMTapAction(name: router.dataDogTapAction(named: rightButtonTitle))
                }
            }.padding(.top, 10)
        }.padding(15)
         .background(RoundedRectangle(cornerRadius: 15).fill(fillColor))
    }
}

#Preview {
    Placeholder(headline: "You haven’t created a troov for any one to join you.",
                        subHeadline: "Here are some trending ideas:",
                        rightButtonAction: { },
                        leftButtonAction: {})
}
