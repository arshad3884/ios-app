//
//  TVerifyService.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.03.24.
//

import Foundation

protocol TVerifyServiceable {
    func sendSmsCode() async -> Result<SuccessResponse, TRequestError>
    func verify(code: VerifySmsCodeForUserRequest) async -> Result<TVerifyService.Response, TRequestError>
}

struct TVerifyService: THTTPClient, THTTPLocalClient, TVerifyServiceable {
    func sendSmsCode() async -> Result<SuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TVerifyEndpoint.sendSmsCode, responseModel: SuccessResponse.self)
    }

    func verify(code: VerifySmsCodeForUserRequest) async -> Result<Response, TRequestError> {
        return await sendRequest(endpoint: TVerifyEndpoint.verify(code: code), responseModel: Response.self)
    }
}

extension TVerifyService {
    struct Code: Codable {
        let userSubmittedCode: Int
    }
}

extension TVerifyService {
    struct Response: Codable {
        var message: String?
    }
}
