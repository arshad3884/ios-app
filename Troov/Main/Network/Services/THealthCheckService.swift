//
//  THealthCheckService.swift
//  Troov
//
//  Created by Levon Arakelyan on 29.06.24.
//

import Foundation

protocol THealthCheckServiceable {
    func checkServerHealth() async -> Result<Bool, TRequestError>
}

struct THealthCheckService: THTTPClient, THTTPLocalClient, THealthCheckServiceable {
    func checkServerHealth() async -> Result<Bool, TRequestError> {
        if TEnvironment.shared.scheme == .demo {
            return .success(.init())
        }
        return await sendRequest(endpoint: THealthCheckEndpoint.serverHealth,
                                 responseModel: Bool.self)
    }
}
