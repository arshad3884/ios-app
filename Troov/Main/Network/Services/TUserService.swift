//
//  TUserService.swift
//  Troov
//
//  Created by Leo on 23.01.23.
//

import Foundation

protocol TUserServiceable {
    func update(userProfile: UserProfile) async -> Result<UserProfile, TRequestError>
    func updateUserAccount(_ user: User) async -> Result<SuccessResponse, TRequestError>
    func info(token: String) async -> Result<User, TRequestError>
    func create(user: User) async -> Result<UserResponse, TRequestError>
    func user(_ userId: String?) async -> Result<User, TRequestError>
    @discardableResult func userProfile(_ userId: String) async -> Result<UserProfile, TRequestError>
}

struct TUserService: THTTPClient, THTTPLocalClient, TUserServiceable {
    func update(userProfile: UserProfile) async -> Result<UserProfile, TRequestError> {
        if TEnvironment.shared.scheme == .demo {
            return .success(.init())
        }
        return await sendRequest(endpoint: TUserEndpoint.update(userProfile: userProfile),
                                 responseModel: UserProfile.self)
    }

    func info(token: String) async -> Result<User, TRequestError> {
        return await sendRequest(endpoint: TUserEndpoint.info(token: token),
                                 responseModel: User.self)
    }

    func create(user: User) async -> Result<UserResponse, TRequestError> {
        return await sendRequest(endpoint: TUserEndpoint.create(user: user),
                                 responseModel: UserResponse.self)
    }

    func user(_ userId: String? = nil) async -> Result<User, TRequestError> {
        if TEnvironment.shared.scheme == .demo {
            return .success(loadJSON(filename: TLocalJson.userProfile.filename, type: User.self))
        }
        
        return await sendRequest(endpoint: TUserEndpoint.user(userId: userId),
                                 responseModel: User.self)
    }

    func userProfile(_ userId: String) async -> Result<UserProfile, TRequestError> {
        return await sendRequest(endpoint: TUserEndpoint.userProfile(userId: userId),
                                 responseModel: UserProfile.self)
    }

    @discardableResult func updateUserAccount(_ user: User) async -> Result<SuccessResponse, TRequestError> {
        return await sendRequest(endpoint: TUserEndpoint.updateUserAccount(user: user),
                                 responseModel: SuccessResponse.self)
    }
}
