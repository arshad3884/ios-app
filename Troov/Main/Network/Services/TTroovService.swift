//
//  TTroovService.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.05.23.
//

import Foundation

protocol TTroovServiceable {
    func troov(by id: String) async -> Result<Troov, TRequestError>
    func create(troov: Troov) async -> Result<TroovResponse, TRequestError>
    func update(troov: Troov) async -> Result<TroovResponse, TRequestError>
    func recommended(by filters: DiscoverFilterSettings) async -> Result<FailableDecodable<DiscoverTroovsResponse>, TRequestError>
    func confirmed() async -> Result<[Troov], TRequestError>
    func open() async -> Result<[Troov], TRequestError>
    func match(by troovId: String) async -> Result<[Troov], TRequestError>
    func join(by troovId: String,
              chat: Chat) async -> Result<SuccessResponse, TRequestError>
    func allMatchRequests() async -> Result<[Troov], TRequestError>
    func confirm(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError>
    func cancelTroov(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError>
    func cancelJoinRequest(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError>
    func declineJoinRequest(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError>
    func localActivityIdeas() -> Result<[TActivityIdea], TRequestError>
}

struct TTroovService: THTTPClient, THTTPLocalClient, TTroovServiceable {
    func update(troov: Troov) async -> Result<TroovResponse, TRequestError> {
        guard troov.troovId != nil else { return .failure(.custom(message: "Troov id is nill for update")) }
        return await sendRequest(endpoint: TTroovEndpoint.update(troov: troov),
                                 responseModel: TroovResponse.self)
    }
    
    func troov(by id: String) async -> Result<Troov, TRequestError> {
        return await sendRequest(endpoint: TTroovEndpoint.troov(id: id),
                                 responseModel: Troov.self)
    }
    
    func create(troov: Troov) async -> Result<TroovResponse, TRequestError> {
        return await sendRequest(endpoint: TTroovEndpoint.create(troov: troov),
                                 responseModel: TroovResponse.self)
    }

    func recommended(by filters: DiscoverFilterSettings) async -> Result<FailableDecodable<DiscoverTroovsResponse>, TRequestError> {
//        if TEnvironment.shared.scheme == .demo {
//            return localTroovs(for: .discoverTroovs)
//        }
        return await sendRequest(endpoint: TTroovEndpoint.recommended(filters: filters),
                                 responseModel: FailableDecodable<DiscoverTroovsResponse>.self)
    }

    func confirmed() async -> Result<[Troov], TRequestError> {
        if TEnvironment.shared.scheme == .demo {
            return localTroovs(for: .confirmedTroovs)
        }
        return await sendRequest(endpoint: TTroovEndpoint.confirmed,
                                 responseModel: [Troov].self)
    }

    func open() async -> Result<[Troov], TRequestError> {
        if TEnvironment.shared.scheme == .demo {
            return localTroovs(for: .myTroovs)
        }
        return await sendRequest(endpoint: TTroovEndpoint.open,
                                 responseModel: [Troov].self)
    }
    
    private func localTroovs(for json: TLocalJson) -> Result<[Troov], TRequestError> {
        if let jsonData = TJsonHelper.readLocalJSONFile(forName: json.filename),
            let troovs = TJSONDecoder.troovs(from: jsonData) {
            return .success(troovs)
        } else {
            return .failure(.custom(message: "Can't load local troovs"))
        }
    }

    func join(by troovId: String,
              chat: Chat) async -> Result<SuccessResponse, TRequestError> {
        debugPrint("☑️ =====>>>> join troov: \(troovId) for user: \(chat.createdByUserId)")
        return await sendRequest(endpoint: TTroovEndpoint.requestToJoinTroov(troovId: troovId, chat: chat),
                                 responseModel: SuccessResponse.self)
    }

    func match(by troovId: String) async -> Result<[Troov], TRequestError> {
        return await sendRequest(endpoint: TTroovEndpoint.match(troovId: troovId),
                                 responseModel: [Troov].self)
    }

    func allMatchRequests() async -> Result<[Troov], TRequestError> {
        if TEnvironment.shared.scheme == .demo {
            return localTroovs(for: .theirTroovs)
        }
        return await sendRequest(endpoint: TTroovEndpoint.allMatch,
                                 responseModel: [Troov].self)
    }

    @discardableResult func confirm(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError> {
        debugPrint("✅ =====>>>> confirm troov: \(troovId) for user: \(userId)")
        return await sendRequest(endpoint: TTroovEndpoint.confirm(troovId: troovId,
                                                                  userId: userId),
                                 responseModel: SuccessResponse.self)
    }

   @discardableResult func cancelTroov(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError> {
        debugPrint("✂️ =====>>>> cancel troov: \(troovId) for user: \(userId)")
        return await sendRequest(endpoint: TTroovEndpoint.cancelTroov(troovId: troovId, userId: userId),
                                 responseModel: SuccessResponse.self)
    }

    @discardableResult func cancelJoinRequest(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError> {
        debugPrint("✂️ =====>>>> cancel join request: \(troovId) for user: \(userId)")
        return await sendRequest(endpoint: TTroovEndpoint.cancelJoinRequest(troovId: troovId, userId: userId),
                                 responseModel: SuccessResponse.self)
    }

    @discardableResult func declineJoinRequest(troovId: String, userId: String) async -> Result<SuccessResponse, TRequestError> {
        debugPrint("✂️ =====>>>> decline join request: \(troovId) for user: \(userId)")
        return await sendRequest(endpoint: TTroovEndpoint.declineJoinRequest(troovId: troovId, userId: userId),
                                 responseModel: SuccessResponse.self)
    }

    func localActivityIdeas() -> Result<[TActivityIdea], TRequestError> {
        if let jsonData = TJsonHelper.readLocalJSONFile(forName: TLocalJson.activityIdeas.filename) {
            do {
                let ideas = try TJSONDecoder.activityIdeas(from: jsonData)
                return .success(ideas)
            } catch {
                return .failure(.custom(message: String(describing: error)))
            }
        } else {
            return .failure(.custom(message: "Can't read local activity ideas"))
        }
    }
}

