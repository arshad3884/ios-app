//
// DiscoverFilterSettings.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** all relevant attributes for filtering troovs */
public struct DiscoverFilterSettings: Codable, JSONEncodable, Hashable {

    static let initialPageLimitRule = NumericRule<Int>(minimum: 1, exclusiveMinimum: false, maximum: 150, exclusiveMaximum: false, multipleOf: nil)
    static let perPageLimitRule = NumericRule<Int>(minimum: 1, exclusiveMinimum: false, maximum: 25, exclusiveMaximum: false, multipleOf: nil)
    static let limitRule = NumericRule<Int>(minimum: 1, exclusiveMinimum: false, maximum: 150, exclusiveMaximum: false, multipleOf: nil)
    public var troovFilters: TroovCoreDetailFilterAttributes
    public var profileFilters: ProfileFilterAttributes
    /** number of troovs to be fetched initially */
    public var initialPageLimit: Int? = 50
    /** number of troovs to be fetched per page while paginating */
    public var perPageLimit: Int?
    /** token to fetch next page of troovs while paginating */
    public var nextPageToken: String?
    public var paginationOrder: PaginationOrder?
    /** total number of troovs that can be fetched from a single query */
    public var limit: Int? = 150
    public var testingMode: Bool? = false

    public init(troovFilters: TroovCoreDetailFilterAttributes, profileFilters: ProfileFilterAttributes, initialPageLimit: Int? = 50, perPageLimit: Int? = nil, nextPageToken: String? = nil, paginationOrder: PaginationOrder? = nil, limit: Int? = 150, testingMode: Bool? = false) {
        self.troovFilters = troovFilters
        self.profileFilters = profileFilters
        self.initialPageLimit = initialPageLimit
        self.perPageLimit = perPageLimit
        self.nextPageToken = nextPageToken
        self.paginationOrder = paginationOrder
        self.limit = limit
        self.testingMode = testingMode
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case troovFilters
        case profileFilters
        case initialPageLimit
        case perPageLimit
        case nextPageToken
        case paginationOrder
        case limit
        case testingMode
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(troovFilters, forKey: .troovFilters)
        try container.encode(profileFilters, forKey: .profileFilters)
        try container.encodeIfPresent(initialPageLimit, forKey: .initialPageLimit)
        try container.encodeIfPresent(perPageLimit, forKey: .perPageLimit)
        try container.encodeIfPresent(nextPageToken, forKey: .nextPageToken)
        try container.encodeIfPresent(paginationOrder, forKey: .paginationOrder)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(testingMode, forKey: .testingMode)
    }
}

