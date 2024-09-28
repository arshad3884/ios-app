//
//  TTroovCoreUserInfoView.swift
//  Troov
//
//  Created by Leo on 10.02.23.
//

import SwiftUI

struct TTroovCoreUserInfoView: View {
    let troov: Troov
    let expand: (() -> ())?

    var body: some View {
        HStack(alignment: .center) {
            TImageView(images: troov.serverImages,
                       size: .init(width: TFImage.smallSize,
                                   height: TFImage.smallSize))
            .clipShape(Circle())
            VStack(alignment: .leading,
                   spacing: 6) {
                HStack(alignment: .center,
                       spacing: 4) {
                    Text("\(troov.firstName),")
                        .fontWithLineHeight(font: .poppins500(size: 14),
                                             lineHeight: 14)
                    Text("\(troov.age)")
                        .fontWithLineHeight(font: .poppins600(size: 16),
                                             lineHeight: 16)
                }
                HStack(alignment: .center,
                       spacing: 0) {
                    Image("t.education")
                        .renderingMode(.template)
                        .padding(.trailing, 2)
                    Text(troov.education)
                        .padding(.trailing, 10)
                    Image("t.profession")
                        .renderingMode(.template)
                        .padding(.trailing, 2)
                    Text(troov.occupation)
                }.foregroundColor(.primaryTroovColor)
                 .fontWithLineHeight(font: .poppins500(size: 11),
                                     lineHeight: 11)
            }.padding(.leading, 18)
            Spacer()
            if let expand = expand {
                Button(action: expand) {
                    TExpendView(isSelected: false)
                }
            }
        }.padding(10)
         .background(Color.primaryTroovColor.opacity(0.06).cornerRadius(8))
    }
}

struct TTroovCoreUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TTroovCoreUserInfoView(troov: .preview,
                               expand: {})
    }
}
