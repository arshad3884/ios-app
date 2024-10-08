//
// SupportCategoryType.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum SupportCategoryType: String, Codable, CaseIterable {
    case bugReport = "BUG_REPORT"
    case complaint = "COMPLAINT"
    case featureRequest = "FEATURE_REQUEST"
    case feedback = "FEEDBACK"
    case generalInquiry = "GENERAL_INQUIRY"
    case requestForHuman = "REQUEST_FOR_HUMAN"
    case nonTroovInquiry = "NON_TROOV_INQUIRY"
}
