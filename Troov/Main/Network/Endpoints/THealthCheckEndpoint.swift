//
//  THealthCheckEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 29.06.24.
//

import Foundation

enum THealthCheckEndpoint {
    case serverHealth
}

extension THealthCheckEndpoint: TEndpoint {
    var name: String? {
        return "healthcheck"
    }
    
    var description: String? {
        return "Healthcheck endpoint"
    }
    
    var path: String {
        switch self {
        case .serverHealth:
            return "/v1/chatSession/delete"
        }
    }

    var method: THTTPMethod? {
        switch self {
        case .serverHealth:
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
    
    var body: TEndpointBody? {
        switch self {
        case .serverHealth:
            return nil
        }
    }
}
