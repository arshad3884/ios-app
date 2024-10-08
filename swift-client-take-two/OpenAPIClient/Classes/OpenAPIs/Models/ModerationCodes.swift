//
// ModerationCodes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** * DRUGS - Content that promotes or glorifies hard drug use (marijuana is acceptable). * HARASSMENT - Content that is abusive, threatening, or harassing. * HATE_SPEECH - Content that promotes discrimination, hatred, or violence against individuals or groups. * OBSCENITY - Content that contains explicit and gross sexual content. * PROFANITY - Content that contains offensive language, including attempts to mask profanity. * PROMOTION - Only content that contains a url or similar. If the content promotes a specific location, then it is acceptable. * PROSTITUTION - Content that promotes or advertises prostitution or the sale of personal sexual services. * SOLICITATION - Content that solicits or requests personal information or financial information. * VIOLENCE - Content that depicts or promotes violence, including physical harm, sexual harm, emotional harm, and self-harm.  */
public enum ModerationCodes: String, Codable, CaseIterable {
    case drugs = "DRUGS"
    case harassment = "HARASSMENT"
    case hateSpeech = "HATE_SPEECH"
    case obscenity = "OBSCENITY"
    case profanity = "PROFANITY"
    case promotion = "PROMOTION"
    case prostitution = "PROSTITUTION"
    case solicitation = "SOLICITATION"
    case violence = "VIOLENCE"
}
