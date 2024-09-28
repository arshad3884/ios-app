//
//  TAdminService.swift
//  Troov
//
//  Created by Levon Arakelyan on 17.11.23.
//

import Foundation

protocol TAdminServiceable {
    func activities() async -> Result<[TroovActivity], TRequestError>
}

struct TAdminService: THTTPClient, THTTPLocalClient, TAdminServiceable {
    func activities() async -> Result<[TroovActivity], TRequestError> {
        return await sendRequest(endpoint: TAdminEndpoint.activities, responseModel: [TroovActivity].self)
    }
}

