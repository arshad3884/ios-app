//
//  THTTPClientDebug.swift
//  Troov
//
//  Created by Levon Arakelyan on 14.07.23.
//

import Foundation

extension THTTPClient {
    func debugRequest(endpoint: TEndpoint,
                      response: URLResponse?,
                      responseData: Data?,
                      error: Error? = nil) async -> String? {
        let isTimeOut = (error as? URLError)?.code == .timedOut
        let isLongPollingTimeOut: Bool

        if endpoint is TNotifyEndpoint {
           isLongPollingTimeOut = isTimeOut
        } else {
            isLongPollingTimeOut = false
        }
        
        var statusCode: Int?
        if let response = response as? HTTPURLResponse {
            statusCode = response.statusCode
        }

        var errorMessage: String?
        var serializationError: Error?
        if let responseData = responseData {
            do {
                let errorMessageObject = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: .fragmentsAllowed)
                errorMessage = String(describing: errorMessageObject)
            } catch {
                errorMessage = String(describing: error)
                serializationError = error
            }
            DataDog.log(message: errorMessage ?? "Unknown",
                        endpoint: endpoint,
                        error: serializationError,
                        statusCode: statusCode,
                        level: isLongPollingTimeOut ? .info : .error)
        } else if let error = error {
            DataDog.log(message: String(describing: error),
                        endpoint: endpoint,
                        error: error,
                        statusCode: statusCode,
                        level: isLongPollingTimeOut ? .info : .error)
        }
        return errorMessage
    }
}
