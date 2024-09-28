//
//  TAdminEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 17.11.23.
//

import Foundation

enum TAdminEndpoint {
    case activities
}

extension TAdminEndpoint: TEndpoint {
    var name: String? {
        return "admin"
    }
    
    var description: String? {
        return "Use existing endpoints with admin permissions and manage users data"
    }
    
    var path: String {
        switch self {
        case .activities:
            return "/v1/troov/getTroovActivityTaxonomy"
        }
    }

    var method: THTTPMethod? {
        switch self {
        case .activities:
            return .get
        }
    }

    var header: [String: String]? {
        get async {
            return [
                "Authorization": "Bearer \(await token)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
}
