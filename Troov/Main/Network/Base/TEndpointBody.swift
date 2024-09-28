//
//  TEndpointBody.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.07.23.
//

import Foundation

enum TEndpointBody: Equatable {
    case form(Data?)
    case json(Encodable)
}

extension TEndpointBody {
    var data: Data? {
        switch self {
        case .form(let data):
            return data
        case .json(let encodable):
            return encodable.data
        }
    }

    var debugLogs: String {
        switch self {
        case .form(let data):
            return "Body is a form data with length: \(data?.count ?? 0)"
        case .json(let encodable):
            return String(describing: encodable)
        }
    }

    /**
     Implement custom Equatable function
     */
    static func == (lhs: TEndpointBody, rhs: TEndpointBody) -> Bool {
        switch (lhs, rhs) {
        case (.form, .form):
            return true
        case (.json, .json):
            return true
        case (.form, .json):
            return false
        default:
            return false
        }
    }
}

