//
//  NetworkManager.swift
//  Troov
//
//  Created by Levon Arakelyan on 23.01.24.
//

import Foundation

class NetworkManager: NSObject {
    static let shared = NetworkManager()

    func result(request: URLRequest, data: Data? = nil, isForm: Bool) async throws -> (Data, URLResponse) {
        if isForm, let data = data {
            return try await URLSession.shared.upload(for: request,
                                                      from: data,
                                                      delegate: self)
        } else {
            return try await URLSession.shared.data(for: request,
                                                    delegate: self)
        }
    }

    private override init() { }
}

/**
 Helps to omit the SSL certificate
 */
extension NetworkManager: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.serverTrust == nil {
            completionHandler(.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }
    }
}
