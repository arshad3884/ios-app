//
//  ProfileMedia+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 16.09.23.
//

import Foundation

extension ProfileMedia {
    func serverImage(by userId: String) -> TServerImage {
       return TServerImage(id: mediaId ?? "",
                           userId: userId,
                           url: mediaUrl,
                           rank: self.rank)
    }
}
