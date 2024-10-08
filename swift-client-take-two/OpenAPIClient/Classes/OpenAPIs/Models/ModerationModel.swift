//
// ModerationModel.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** Describes the model that was used to determine the suitability of a troov (could be human review).  */
public enum ModerationModel: String, Codable, CaseIterable {
    case gpt4o = "gpt-4o"
    case gpt4oMini = "gpt-4o-mini"
    case humanReview = "human_review"
}
