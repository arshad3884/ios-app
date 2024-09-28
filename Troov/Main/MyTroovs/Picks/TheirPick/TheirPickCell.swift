//
//  TheirPickCell.swift
//  Troov
//
//  Created by Levon Arakelyan on 29.09.23.
//

import SwiftUI

struct TheirPickCell: View {
    let troov: Troov
    let userId: String

    let removePick: (Troov) -> ()
    
    private var images: [TServerImage] {
        troov.serverImages ?? []
    }

    private var timeLeftIsCritical: (String, Bool) {
        return troov.timeLeftIsCritical(userId: userId)
    }

    var body: some View {
        HStack(alignment: .center,
               spacing: 18) {
                TImageView(images: images,
                           size: .init(width: 50,
                                       height: 50))
                .clipShape(Circle())
            VStack(alignment: .leading,
                   spacing: 4) {
                Text(troov.createdBy?.firstName ?? "")
                    .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 21)
                    .foregroundStyle(Color.rgba(51, 51, 51, 1))
                Text(troov.title)
                    .fontWithLineHeight(font: .poppins400(size: 12), lineHeight: 18)
                    .foregroundStyle(Color.rgba(51, 51, 51, 1))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(alignment: .center, spacing: 6) {
                    TPickTimeLabel(isCritical: timeLeftIsCritical.1,
                                   text: timeLeftIsCritical.0)
                    Button(action: { removePick(troov) }, label: {
                        Image("t.xmark")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.white)
                            .frame(width: 11, height: 11)
                            .padding(.horizontal, 15.5)
                            .padding(.vertical, 7)
                            .background(Color.primaryTroovRed)
                            .clipShape(Capsule())
                    })
                }
            }.padding(.vertical, 10)
            TimeLocationView(troov: troov)
                .padding(.vertical, 10)
        }
               .padding(.horizontal, 10)
               .background(RoundedRectangle(cornerRadius: 8)
               .fill(Color.white))
               .frame(maxHeight: 112)
    }
}

#Preview {
    TheirPickCell(troov: .preview,
                  userId: "") {_ in}
}
