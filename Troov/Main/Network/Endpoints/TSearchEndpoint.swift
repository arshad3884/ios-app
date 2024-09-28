//
//  TSearchEndpoint.swift
//  Troov
//
//  Created by Levon Arakelyan on 22.01.24.
//

import Foundation

enum TSearchEndpoint {
    case mostPopularTags(count: Int)
    case activeTags
    case searchByTerm(term: String,
                      latitude: Double,
                      longitude: Double,
                      radius: Double)
}

extension TSearchEndpoint: TEndpoint {
    var name: String? {
        return "discover"
    }
    
    var description: String? {
        return "Search and find new troovs"
    }
    
    var path: String {
        switch self {
        case .mostPopularTags(let count):
            return "/v1/discover/tags/mostPopular/\(count)"
        case .activeTags:
            return "/v1/discover/tags/active"
        case .searchByTerm(let term, _, _, _):
            return "/v1/discover/troovs/search/\(term)"
        }
    }
    
    var method: THTTPMethod? {
        switch self {
        case .mostPopularTags, .activeTags, .searchByTerm:
            return .get
        }
    }
    
    var header: [String: String]? {
        get async {
            return [
                "Authorization": "Bearer \(await token)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchByTerm(_, let latitude, let longitude, let radius):
            return [URLQueryItem(name: "queryLatitude", value: "\(latitude)"),
                    URLQueryItem(name: "queryLongitude", value: "\(longitude)"),
                    URLQueryItem(name: "queryRadius", value: "\(radius)")]
        default:
            return nil
        }
    }
}
