//
//  TEnvironment.swift
//  Troov
//
//  Created by Leo on 13.10.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import Foundation

struct TEnvironment {
    var scheme: TSceme?
    static let shared = TEnvironment()

    init() {
        if let rawValue = Bundle.main.infoDictionary?["TScheme"] as? String,
           let scheme = TSceme(rawValue: rawValue) {
            self.scheme = scheme
        }
    }
}

extension TEnvironment {
    var host: String? {
        guard let scheme = scheme else { return nil}
        switch scheme {
        case .local:
            return "localhost"
        case .staging:
            return "staging-api.troov.app"
        case .demo:
            return "LOCAL_APP"
        case .prod:
            return "prod-api.troov.app"
        case .dev:
            return "dev-api.troov.app"
        }
    }

    var hostScheme: String? {
        return "https"
    }

    var port: Int? {
        if hostScheme == "http" && scheme == .local {
            return 8080
        }
        return nil
    }
}

enum TEnvironmentFields: String {
    case scheme
}

extension TEnvironmentFields {
    var field: String {
        return rawValue
    }
}
