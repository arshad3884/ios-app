//
//  PickDetailCell.swift
//  mango
//
//  Created by Leo on 18.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct PickDetailCell: View {
    let match: TroovMatchRequest
    let viewRequest: (TroovMatchRequest) -> ()
    let decline: (TroovMatchRequest) -> ()
    let accept: (TroovMatchRequest) -> ()
    let reply: (TroovMatchRequest) -> ()
    
    private var firstName: String {
        if let firstName = match.requester?.firstName {
            return firstName
        }
        return ""
    }
    
    private var age: String {
        if let age = match.requester?.age {
            return "\(age)"
        }
        return ""
    }
    
    private var images: [TServerImage] {
        if let images = match.requester?.images {
            return images
        }
        return []
    }

    private var timeLeftIsCritical: (String, Bool) {
        if let expiresAt = match.expiresAt {
            return expiresAt.timeLeftIsCritical
        }
        return ("Expired", true)
    }
    
    private var openingChatMessage: String {
        return "\"" + "\(match.openingChatMessage ?? "")" + "\""
    }
    
    private let cellHeight = 176.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            TroovCellExpandedImageSlider(name: firstName,
                               age: age,
                               images: images,
                               detailsTitle: "View Profile ->",
                               seeDetails: { viewRequest(match) })
            .padding(4)
            HStack {
                Text(openingChatMessage)
                    .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 12)
                    .foregroundStyle(Color.rgba(33, 33, 33, 1))
                    .lineLimit(3)
                    .padding(15)
                    .background {
                        Color.rgba(237, 237, 237, 1)
                    }
                    .clipShape(RoundedShape(radius: 30, corners: [.bottomLeft, .bottomRight, .topRight]))
                Spacer()
            }.padding(.horizontal, 16)
            TroovRequestView.BottomBarView(accept: {
                accept(match)
            },
                                           reply: { reply(match) },
                                           decline: { decline(match) })
            .padding(.horizontal, 16)
            TPickTimeLabel(isCritical: timeLeftIsCritical.1,
                           text: timeLeftIsCritical.0)
            .padding(.bottom, 15)
            .padding(.horizontal, 16)
        }.background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
    }
}

struct PickDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        PickDetailCell(match: .init()) {_ in }
    decline: {_ in}
    accept: { _ in}
    reply: { _ in}
    }
}

extension PickDetailCell {
    struct ViewRequestLabel: View {
        var body: some View {
            Text("View Request")
                .fontWithLineHeight(font: .poppins500(size: 12),
                                    lineHeight: 18)
                .foregroundStyle(Color.white)
                .padding(7.5)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(Color.primaryTroovColor))
        }
    }
}

