//
//  THTTPClient.swift
//  Troov
//
//  Created by Leo on 23.01.23.
//

import Foundation

protocol THTTPClient {
    func sendRequest<T: Decodable>(endpoint: TEndpoint,
                                   responseModel: T.Type) async -> Result<T, TRequestError>
    var userId: String? { get }
}

extension THTTPClient {
    func sendImageDataRequest(endpoint: TEndpoint) async -> Result<Data, TRequestError> {
        guard let url = URL(string: endpoint.path) else {
            return .failure(.custom(message: "Invalid url"))
        }
        let request = URLRequest(url: url, timeoutInterval: .infinity)
        do {
            let (data, _) = try await NetworkManager.shared.result(request: request,
                                                                    isForm: false)
            return .success(data)
        } catch {
            if let message = await debugRequest(endpoint: endpoint,
                                                response: nil,
                                                responseData: nil,
                                                error: error) {
                return .failure(.custom(message: message))
            } else {
                return .failure(.custom(message: String(describing: error)))
            }
        }
    }
    
    func sendRequest<T: Decodable>(endpoint: TEndpoint,
                                   responseModel: T.Type) async -> Result<T, TRequestError> {
        let body = endpoint.body
        let data = body?.data
        let requestTimeout = endpoint.timeoutInterval
        var isForm = false
        if case .form = body {
            isForm = true
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port
        
        if let queryItems = endpoint.queryItems {
           urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url, timeoutInterval: requestTimeout)
        if let method = endpoint.method?.rawValue {
            request.httpMethod = method
        }
        request.allHTTPHeaderFields = await endpoint.header
        if !isForm {
            request.httpBody = data
        }
        do {
            let (data, response) = try await NetworkManager.shared.result(request: request,
                                                                          data: data,
                                                                          isForm: isForm)
            guard let response = response as? HTTPURLResponse else {
                if let message = await debugRequest(endpoint: endpoint,
                                                    response: response,
                                                    responseData: data) {
                    return .failure(.custom(message: message))
                } else {
                    return .failure(.noResponse)
                }
            }
            
            switch response.statusCode {
            case 200...299:
                do {
                    let decoded = TJSONDecoder.decoder
                    let decodedResponse = try decoded.decode(responseModel, from: data)
                    return .success(decodedResponse)
                } catch {
                    if let message = await debugRequest(endpoint: endpoint,
                                                        response: response,
                                                        responseData: nil,
                                                        error: error) {
                        return .failure(.custom(message: message))
                    } else {
                        return .failure(.custom(message: String(describing: error)))
                    }
                }
            case 401:
                if let message = await debugRequest(endpoint: endpoint,
                                                    response: response,
                                                    responseData: data) {
                    return .failure(.custom(message: message))
                } else {
                    return .failure(.unauthorized)
                }
            default:
                if let message = await debugRequest(endpoint: endpoint,
                                              response: response,
                                              responseData: data) {
                    return .failure(.custom(message: message))
                } else {
                    return .failure(.unexpectedStatusCode)
                }
            }
        } catch {
            if let message = await debugRequest(endpoint: endpoint,
                                                response: nil,
                                                responseData: nil,
                                                error: error) {
                if let error = error as? URLError,
                   case .timedOut = error.code {
                    return .failure(.timeout)
                }
                return .failure(.custom(message: message))
            } else {
                if let error = error as? URLError,
                   case .timedOut = error.code {
                    return .failure(.timeout)
                }
                return .failure(.custom(message: String(describing: error)))
            }
        }
    }
    
    var userId: String? {
        TAuth0.shared.userInfo?.sub
    }
}
