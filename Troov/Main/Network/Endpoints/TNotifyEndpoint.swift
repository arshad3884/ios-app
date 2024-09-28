//
//  TNotifyEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.08.23.
//

import Foundation

enum TNotifyEndpoint {
    case notify
}

extension TNotifyEndpoint: TEndpoint {
    var name: String? {
        return "notify"
    }
    
    var description: String? {
        return "Long polling operations"
    }
    
    var path: String {
        return "/v1/notify/notifications/\(userId)/longPolling"
    }

    var method: THTTPMethod? {
        return .get
    }

    var header: [String: String]? {
        get async {
            return [
                "Authorization": "Bearer \(await token)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }

    /**
     1. It was throwing a server internal warning with a code 504 when we specify higher or equal than 60 seconds
     2. Changed from 45 to 180 seconds
     */
    var timeoutInterval: TimeInterval {
       return 180
    }
}
