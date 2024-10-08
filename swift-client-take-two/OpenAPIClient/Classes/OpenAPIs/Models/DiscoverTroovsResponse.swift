//
// DiscoverTroovsResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** represents the response of the discover troovs endpoint */
public struct DiscoverTroovsResponse: Codable, JSONEncodable, Hashable {

    static let numTroovsFoundRule = NumericRule<Int>(minimum: 0, exclusiveMinimum: false, maximum: nil, exclusiveMaximum: false, multipleOf: nil)
    /** a list of troovs */
    public var troovs: [Troov]
    /** A token to be used to fetch the next page of results, null if there are no more results. */
    public var nextPageToken: String?
    /** total number of troovs found in the search query */
    public var numTroovsFound: Int

    public init(troovs: [Troov], nextPageToken: String? = nil, numTroovsFound: Int) {
        self.troovs = troovs
        self.nextPageToken = nextPageToken
        self.numTroovsFound = numTroovsFound
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case troovs
        case nextPageToken
        case numTroovsFound
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(troovs, forKey: .troovs)
        try container.encodeIfPresent(nextPageToken, forKey: .nextPageToken)
        try container.encode(numTroovsFound, forKey: .numTroovsFound)
    }
}

