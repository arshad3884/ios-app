//
//  TProfileMedia.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.07.23.
//

import UIKit

typealias TProfileMedia = Compose<ProfileMedia, TMediaPick>

struct TMediaPick: Identifiable {
    var id = UUID().uuidString
    var image: UIImage?
    var data: Data?
    var failure: String?
    var inProgress: Bool = false
    var finished: Bool = false

    init() {}
}

extension TMediaPick {
    var isActive: Bool {
        get {
           return image != nil
        }
    }
}

extension TProfileMedia {
    func failedRespone(reason: String) -> MediaUploadResponse.Failed {
        return MediaUploadResponse.Failed.init(success: false,
                                               profileMedia: .init(mediaId: self.id),
                                               error: reason)
    }

    static var initialMedia: [TProfileMedia] {
        [.init(.init(mediaId: UUID().uuidString,
                     rank: 0), .init()),
         .init(.init(mediaId: UUID().uuidString,
                     rank: 1), .init()),
         .init(.init(mediaId: UUID().uuidString,
                     rank: 2), .init()),
         .init(.init(mediaId: UUID().uuidString,
                     rank: 3), .init()),
         .init(.init(mediaId: UUID().uuidString,
                     rank: 4), .init())]
    }
}


