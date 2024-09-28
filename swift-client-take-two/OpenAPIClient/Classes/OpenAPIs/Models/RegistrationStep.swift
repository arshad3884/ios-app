//
// RegistrationStep.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public enum RegistrationStep: String, Codable, CaseIterable {
    case doItLaterOption = "DO_IT_LATER_OPTION"
    case readOnlyBrowsing = "READ_ONLY_BROWSING"
    case phoneNumber = "PHONE_NUMBER"
    case codeSent = "CODE_SENT"
    case codeReceived = "CODE_RECEIVED"
    case marketingChannels = "MARKETING_CHANNELS"
    case relationshipInterests = "RELATIONSHIP_INTERESTS"
    case activityInterests = "ACTIVITY_INTERESTS"
    case nameAndBirthday = "NAME_AND_BIRTHDAY"
    case gender = "GENDER"
    case almaMaterOccupationCompany = "ALMA_MATER_OCCUPATION_COMPANY"
    case height = "HEIGHT"
    case education = "EDUCATION"
    case ethnicity = "ETHNICITY"
    case politics = "POLITICS"
    case religion = "RELIGION"
    case imageUpload = "IMAGE_UPLOAD"
    case tutorial = "TUTORIAL"
    case complete = "COMPLETE"
}
