//
//  MediaUploadResponse.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.08.23.
//

import Foundation

struct MediaUploadResponse: Codable {
    var successful_upload: [ProfileMedia]?
    var failed_upload: [Failed]?
}

extension MediaUploadResponse {
    struct Failed: Codable {
        let success: Bool
        let profileMedia: Media
        let error: String
    }
}

extension MediaUploadResponse.Failed {
    struct Media: Codable {
        let mediaId: String
    }

    var errorMessage: String {
        if error.contains("unsafe") {
            return "unsafe"
        } else {
            return "error"
        }
    }
}

