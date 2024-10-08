//
// TroovMatchRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** A single instance of a match request initiated by a user wanting to join a troov. */
public struct TroovMatchRequest: Codable, JSONEncodable, Hashable {

    public enum Status: String, Codable, CaseIterable {
        case confirmed = "CONFIRMED"
        case declined = "DECLINED"
        case pending = "PENDING"
        case cancelled = "CANCELLED"
        case expired = "EXPIRED"
    }
    static let chatSessionIdRule = StringRule(minLength: nil, maxLength: nil, pattern: "/^[\\w\\-\\|]+$/")
    /** Status of the match request:  * CONFIRMED   | The creator of the troov has approved the request  * DECLINED    | The creator of the troov has declined this request  * PENDING     | The requester is still pending a reply from the troov creator  * CANCELLED   | The requester has cancelled this troov request  * EXPIRED     | This troov request has expired  */
    public var status: Status? = .pending
    public var requester: UserProfileWithUserId?
    public var requestedAt: Date?
    public var expiresAt: Date?
    /** the last time at which the status was updated */
    public var statusUpdatedAt: Date?
    /** the prior status */
    public var lastStatus: String?
    /** store the first message here for easy accessibility to the frontend */
    public var openingChatMessage: String?
    /** the id of the chat session associated with this troov match request */
    public var chatSessionId: String?
    /** the troov to which this request belongs */
    public var troovId: String?

    public init(status: Status? = .pending, requester: UserProfileWithUserId? = nil, requestedAt: Date? = nil, expiresAt: Date? = nil, statusUpdatedAt: Date? = nil, lastStatus: String? = nil, openingChatMessage: String? = nil, chatSessionId: String? = nil, troovId: String? = nil) {
        self.status = status
        self.requester = requester
        self.requestedAt = requestedAt
        self.expiresAt = expiresAt
        self.statusUpdatedAt = statusUpdatedAt
        self.lastStatus = lastStatus
        self.openingChatMessage = openingChatMessage
        self.chatSessionId = chatSessionId
        self.troovId = troovId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case status
        case requester
        case requestedAt
        case expiresAt
        case statusUpdatedAt
        case lastStatus
        case openingChatMessage
        case chatSessionId
        case troovId
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(requester, forKey: .requester)
        try container.encodeIfPresent(requestedAt, forKey: .requestedAt)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(statusUpdatedAt, forKey: .statusUpdatedAt)
        try container.encodeIfPresent(lastStatus, forKey: .lastStatus)
        try container.encodeIfPresent(openingChatMessage, forKey: .openingChatMessage)
        try container.encodeIfPresent(chatSessionId, forKey: .chatSessionId)
        try container.encodeIfPresent(troovId, forKey: .troovId)
    }
}

