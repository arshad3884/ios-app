//
//  TChatService.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.08.23.
//

import Foundation

protocol TChatServiceable {
    func session(id: String) async -> Result<ChatSession, TRequestError>
    func add(chat: Chat) async -> Result<SuccessResponse, TRequestError>
    func create(session: ChatSession) async -> Result<SuccessResponse, TRequestError>
    func activeSessions() async -> Result<[ChatSession], TRequestError>
    func addChat(sessiondId: String, message: Chat) async -> Result<ChatSuccessResponse, TRequestError>
    @discardableResult func delete(sessionId: String) async -> Result<SuccessResponse, TRequestError>
    @discardableResult func sessionViewedBy(sessionId: String) async -> Result<SuccessResponse, TRequestError>
}

struct TChatService: THTTPClient, THTTPLocalClient, TChatServiceable {
    func sessionViewedBy(sessionId: String) async -> Result<SuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.sessionViewedBy(sessionId: sessionId),
                                 responseModel: SuccessResponse.self)
    }
    
    func session(id: String) async -> Result<ChatSession, TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.session(id: id), responseModel: ChatSession.self)
    }

    func add(chat: Chat) async -> Result<SuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.add(chat: chat), responseModel: SuccessResponse.self)
    }

   @discardableResult func create(session: ChatSession) async -> Result<SuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.create(session: session), responseModel: SuccessResponse.self)
    }

    func activeSessions() async -> Result<[ChatSession], TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.activeSessions, responseModel: [ChatSession].self)
    }

    func addChat(sessiondId: String, message: Chat) async -> Result<ChatSuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.addChat(sessionId: sessiondId, message: message), responseModel: ChatSuccessResponse.self)
    }

   @discardableResult func delete(sessionId: String) async -> Result<SuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TChatEndpoint.delete(sessionId: sessionId), responseModel: SuccessResponse.self)
    }
}
