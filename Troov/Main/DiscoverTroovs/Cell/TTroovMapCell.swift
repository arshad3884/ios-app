//
//  TTroovMapCell.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct TTroovMapCell: View {
    let troov: Troov
    let userId: String?
    
    private var isOwnTroov: Bool {
        troov.createdBy?.userId == userId
    }

    let openChatSession: (Troov) -> ()

    private let height: CGFloat = 176
    
    private var serverImages: [TServerImage] {
        troov.serverImages ?? []
    }

    var body: some View {
        HStack(spacing: 10.relative(to: .width)) {
            ExpendedImageSlider(serverImages: serverImages,
                                hideIndicator: true)
                .aspectRatio(TFImage.reverseScale, contentMode: .fit)
                .cornerRadius(20.relative(to: .height))
                .overlay(alignment: .bottomLeading) {
                    MaterialLabel(name: troov.firstName,
                                       age: troov.age)
                    .padding(6)
                }
            VStack(alignment: .leading,
                   spacing: 0) {
                Spacer()
                HStack(alignment: .center) {
                    Text(troov.title)
                        .fontWithLineHeight(font: .poppins500(size: 16),
                                            lineHeight: 16)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .layoutPriority(1)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }.background(Color.white)
                Spacer()
                TCalendarCellView(troov: troov,
                                  hideLocation: true) {}
                HStack(spacing: 5) {
                    if let indicator = troov.locationDetails {
                        TCalendarCellView.LocationView(indicator: indicator)
                    }
                    Spacer()
                    Button(action: { openChatSession(troov) }) {
                        Image("t.chat.icon")
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                    }.buttonStyle(.scalable)
                     .opacity(isOwnTroov ? 0.0 : 1.0)
                     .disabled(isOwnTroov)
                }.padding(.vertical, 10)
            }.padding(.trailing, 10.relative(to: .width))
        }.frame(height: height)
            .background(content: {
                RoundedRectangle(cornerRadius: 20.relative(to: .height))
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.4), radius: 4, y: 4)
            }).padding(.bottom, 10)
    }
}

struct TTroovMapCell_Previews: PreviewProvider {
    static var previews: some View {
        TTroovMapCell(troov: .preview,
                      userId: nil,
                      openChatSession: {_ in})
    }
}
