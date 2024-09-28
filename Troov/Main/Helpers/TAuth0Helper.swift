//
//  TAuth0Helper.swift
//  Troov
//
//  Created by Leo on 28.02.23.
//

import Foundation
import Auth0

struct TAuth0 {
    static let shared = TAuth0()
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

    public var plist: Plist { Bundle.main.decodePropertyList("Auth0") }
    public var audience: String { "https://troov-dev" }
    public var userInfo: UserInfo? { credentialsManager.user }
    
    public var accessToken: String {
        get async throws {
            return try await credentialsManager.credentials().accessToken
        }
    }
    
    /**
     It seems we don't use refresh tokens???
     var canRenew: Bool {
     credentialsManager.canRenew()
     }
     */
    
    public var hasValid: Bool { credentialsManager.hasValid() }
    
    public func start(parameter: TAuth0.`Type`) async throws {
        let plist = TAuth0.shared.plist
        let credentials = try await Auth0
            .webAuth(clientId: plist.ClientId,
                     domain: plist.Domain)
            .audience(TAuth0.shared.audience)
            .scope("openid profile email")
            .useEphemeralSession()
            .parameters(parameter.hint)
            .start()
        try store(credentials: credentials)
    }
    
    public func logout() {
        if credentialsManager.clear() {
            DispatchQueue.main.async {
                User.setUserLocation(nil)
                ProfileViewModel.shared.cleanUp()
                CachedImage.shared().cleanUp()
                UserDefaults.standard.removeObject(forKey: "t.removed.troov.ids")
                DataDog.setUserInfo(userId: nil)
            }
        }
    }
    
    private func store(credentials: Credentials) throws {
        if !credentialsManager.store(credentials: credentials) {
            throw TAuth0Error.storeCredentails
        }
    }
    
    private init() {
        /** https://auth0.com/docs/libraries/auth0-swift/auth0-swift-save-and-renew-tokens#credentials-check
         * We should make sure to remove all keychain credentails when app runs the first time
         * Per documentation
         * `The Keychain items do not get deleted after your app is uninstalled.
         *  We recommend to always clear all of your app's Keychain items on first launch.`
         */
        if !TKeychainItems.launched.storedUDBoolValue {
            TKeychainItems.launched.setBoolUD(value: true)
            logout()
        }
    }
}

extension TAuth0 {
    struct Plist: Codable {
        let ClientId: String
        let Domain: String
    }
}

extension TAuth0 {
    enum `Type` {
        case signIn
        case signUp
    }
}

extension TAuth0.`Type` {
    var hint: [String: String] {
        switch self {
        case .signIn:
            return ["screen_hint": "signin"]
        case .signUp:
            return ["screen_hint": "signup"]
        }
    }
}
