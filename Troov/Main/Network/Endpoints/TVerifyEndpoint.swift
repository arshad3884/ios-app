//
//  TVerifyEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.03.24.
//

import Foundation

enum TVerifyEndpoint {
    case sendSmsCode
    case verify(code: VerifySmsCodeForUserRequest)
}

extension TVerifyEndpoint: TEndpoint {
    var name: String? {
        return "verify"
    }
    
    var description: String? {
        return "Operations for verifying user information"
    }
    
    var path: String {
        switch self {
        case .sendSmsCode:
            return "/v1/verify/sendSmsCodeForUser/\(userId)"
        case .verify:
            return "/v1/verify/verifySmsCodeForUser/\(userId)"
        }
    }
    
    var method: THTTPMethod? {
        return .post
    }
    
    var header: [String: String]? {
        get async {
            return [
                "Authorization": "Bearer \(await token)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }

    var body: TEndpointBody? {
        switch self {
        case .verify(let code):
            return .json(code)
        default:
            return nil
        }
    }
}
