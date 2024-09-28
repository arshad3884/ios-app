//
// TroovIndexedFields.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** helper query lookup fields (related to Firestore implementation) */
public struct TroovIndexedFields: Codable, JSONEncodable, Hashable {

    /** a list of all the user ids which have requested a match for this troov */
    public var matchRequestUserIds: [String]?
    /** the users ids of the creator and confirmed matcher */
    public var confirmedUserIds: [String]?
    /** a list of all the user ids which should be notified upon updates to this troov */
    public var notifyUserIds: [String]?
    /** a list of all the activity categories and concatenated sub labels associated with the troov for searching  */
    public var activityCategorySubLabels: [String]?

    public init(matchRequestUserIds: [String]? = nil, confirmedUserIds: [String]? = nil, notifyUserIds: [String]? = nil, activityCategorySubLabels: [String]? = nil) {
        self.matchRequestUserIds = matchRequestUserIds
        self.confirmedUserIds = confirmedUserIds
        self.notifyUserIds = notifyUserIds
        self.activityCategorySubLabels = activityCategorySubLabels
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case matchRequestUserIds
        case confirmedUserIds
        case notifyUserIds
        case activityCategorySubLabels
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(matchRequestUserIds, forKey: .matchRequestUserIds)
        try container.encodeIfPresent(confirmedUserIds, forKey: .confirmedUserIds)
        try container.encodeIfPresent(notifyUserIds, forKey: .notifyUserIds)
        try container.encodeIfPresent(activityCategorySubLabels, forKey: .activityCategorySubLabels)
    }
}

