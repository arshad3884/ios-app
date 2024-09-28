//
//  ActiveChannelImageView.swift
//  mango
//
//  Created by Leo on 25.03.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

struct ActiveChannelImageView: View {    
    var images: [TServerImage]?
    let state: ChatSession.State

    var body: some View {
        VStack {
            TImageView(images: images,
                       size: .init(width: 50,
                                   height: 50))
            .clipShape(Circle())
        }.overlay(alignment: .topTrailing, content: {
            if state == .unread {
                /**
                 let count = session.messages?.count,
                 count > 0
                 This is temporary, since we agreed on showing only purple badge in case
                 current user hasn't responded to any messages yet
                 CircleFillLabel(text: "\(count)")
                 */
                CircleFillLabel(text: " ")
                    .padding(.top, -6)
            }
        })
    }
}

struct ActiveChannelImageView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChannelImageView(images: [],
                               state: .unread)
    }
}
