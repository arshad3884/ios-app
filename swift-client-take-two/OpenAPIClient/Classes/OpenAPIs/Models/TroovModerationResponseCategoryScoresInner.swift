//
// TroovModerationResponseCategoryScoresInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct TroovModerationResponseCategoryScoresInner: Codable, JSONEncodable, Hashable {

    static let scoreRule = NumericRule<Float>(minimum: 0, exclusiveMinimum: false, maximum: 1, exclusiveMaximum: false, multipleOf: nil)
    public var category: ModerationCodes?
    public var score: Float?

    public init(category: ModerationCodes? = nil, score: Float? = nil) {
        self.category = category
        self.score = score
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case category
        case score
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(score, forKey: .score)
    }
}

