//
//  TEndpoint.swift
//  Troov
//
//  Created by Leo on 23.01.23.
//

import Foundation

protocol TEndpoint {
    var port: Int? { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: THTTPMethod? { get }
    var header: [String: String]? { get async }
    var body: TEndpointBody? { get }
    var timeoutInterval: TimeInterval { get }
    var name: String? { get }
    var description: String? { get }
    var queryItems: [URLQueryItem]? { get }
}

/**
 By default
 */
extension TEndpoint {

    var port: Int? {
        return TEnvironment.shared.port
    }
    
    var scheme: String {
        return TEnvironment.shared.hostScheme ?? ""
    }
    
    var host: String {
        return TEnvironment.shared.host ?? ""
    }
    
    var token: String {
        get async {
            do {
                return try await TAuth0.shared.accessToken
            } catch {
                return ""
            }
        }
    }
    
    var userId: String {
        TAuth0.shared.userInfo?.sub ?? ""
    }

    /**
     By default
     */
    var timeoutInterval: TimeInterval {
       return 20
    }

    var body: TEndpointBody? { nil }
    
    var queryItems: [URLQueryItem]? { nil }
}

extension TEndpoint {
    func loggerAttributes(statusCode: Int? = nil) -> [String: Codable] {
        return ["name" : name,
                "description": description,
                "port": port,
                "scheme": TEnvironment.shared.scheme?.rawValue ?? "Unknown",
                "apihost": host,
                "path": path,
                "method": method?.rawValue,
                "timeoutInterval": timeoutInterval,
                "statusCode": statusCode,
        ]
    }
}
