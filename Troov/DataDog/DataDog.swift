//
//  DataDog.swift
//  Troov
//
//  Created by Levon Arakelyan on 25.04.24.
//

import Foundation
import DatadogCore
import DatadogRUM
import DatadogLogs
import DatadogSessionReplay
import DatadogCrashReporting

enum DataDog {
    static func initialize() {
        let appID = "be7ed35b-4911-4a6d-8be1-f50e1aaf6d0a"
        let clientToken = "puba6786fb5c7a344d051ac1b150ec0aa1c"
        let environment = TEnvironment.shared.scheme?.rawValue ?? "Unknown"
        
        Datadog.initialize(
            with: Datadog.Configuration(
                clientToken: clientToken,
                env: environment,
                site: .us5
            ),
            trackingConsent: .granted
        )

        RUM.enable(
            with: RUM.Configuration(
                applicationID: appID,
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate(),
                trackBackgroundEvents: true
            )
        )
        
        
        /**
         replaySampleRate
         https://docs.datadoghq.com/fr/real_user_monitoring/session_replay/mobile/setup_and_configuration?tab=ios#régler-la-fréquence-déchantillonnage-pour-lʼaffichage-des-sessions-enregistrées
         */
        SessionReplay.enable(
             with: SessionReplay.Configuration(
                 replaySampleRate: 100
             )
         )
         
        Logs.enable()
        /**
         Added crash reporting
         */
        CrashReporting.enable()
    }

    static func log(message: String,
                    endpoint: TEndpoint,
                    error: Error? = nil,
                    statusCode: Int? = nil,
                    level: LogLevel = .error) {
            let logger = Logger.create()
            logger.addTag(withKey: "service",
                          value: "troov-ios-app")        
            logger.addTag(withKey: "bundleId",
                          value: Bundle.main.bundleIdentifier ?? "Unknown")
            logger.addTag(withKey: "iOSDeviceToken",
                          value: TKeychain.getStringValue(key: TKeychainItems.deviceNotificationToken.rawValue) ?? "Unknown")
            logger.addTag(withKey: "authuserid",
                          value: TAuth0.shared.userInfo?.sub ?? "Unknown")
        
            logger.addTag(withKey: "scheme",
                          value: TEnvironment.shared.scheme?.rawValue ?? "Unknown")
        
            logger.addTag(withKey: "apihost",
                          value: endpoint.host)
        
            logger.addTag(withKey: "route",
                          value: endpoint.path)
            logger.log(level: level,
                       message: message,
                       error: error,
                       attributes: endpoint.loggerAttributes(statusCode: statusCode))
           debugPrint("====>> DataDag message: \(message), status code: \(statusCode), endpoint: \(endpoint)")
    }
    
    static func log(message: String,
                    level: LogLevel = .error,
                    attributes: [String: any Encodable]? = nil) {
            let logger = Logger.create()
            logger.addTag(withKey: "service",
                          value: "troov-ios-app")
            logger.addTag(withKey: "bundleId",
                          value: Bundle.main.bundleIdentifier ?? "Unknown")
            logger.addTag(withKey: "iOSDeviceToken",
                          value: TKeychain.getStringValue(key: TKeychainItems.deviceNotificationToken.rawValue) ?? "Unknown")
            logger.addTag(withKey: "authuserid",
                          value: TAuth0.shared.userInfo?.sub ?? "Unknown")
            logger.addTag(withKey: "scheme",
                          value: TEnvironment.shared.scheme?.rawValue ?? "Unknown")
            logger.log(level: level,
                       message: message,
                       error: nil,
                       attributes: attributes)
            debugPrint(message)
    }

    static func setUserInfo(userId: String?) { Datadog.setUserInfo(id: userId) }
}
