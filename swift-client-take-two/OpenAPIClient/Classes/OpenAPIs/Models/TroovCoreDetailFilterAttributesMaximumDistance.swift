//
// TroovCoreDetailFilterAttributesMaximumDistance.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct TroovCoreDetailFilterAttributesMaximumDistance: Codable, JSONEncodable, Hashable {

    public enum Unit: String, Codable, CaseIterable {
        case mile = "MILE"
    }
    static let lengthRule = NumericRule<Double>(minimum: 0.1, exclusiveMinimum: false, maximum: 10000, exclusiveMaximum: false, multipleOf: nil)
    public var length: Double? = 1
    public var unit: Unit?

    public init(length: Double? = 1, unit: Unit? = nil) {
        self.length = length
        self.unit = unit
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case length
        case unit
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(length, forKey: .length)
        try container.encodeIfPresent(unit, forKey: .unit)
    }
}

