//
//  TError.swift
//  Troov
//
//  Created by Leo on 14.10.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import Foundation

enum TAuth0Error: Error {
    case storeCredentails

    var message: String {
        switch self {
        case .storeCredentails:
            return "Unable to store credentails"
        }
    }
}

enum TRequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case custom(message: String)
    case mediaFailed([MediaUploadResponse.Failed]?)
    case timeout

    var message: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .unauthorized:
            return "Session expired"
        case .custom(let message):
            return message
        case .mediaFailed(let media):
            var message = ""
            if let media = media {
                for item in media {
                    message += "media with id: \(item.profileMedia.mediaId) has this issue \(item.error)\n"
                }
            }
            return message
        case .timeout:
            return "Request's time is out"
        default:
            return String(describing: self)
        }
    }

    var isTimeout: Bool {
        switch self {
        case .timeout:
            return true
        default:
            return false
        }
    }
}
