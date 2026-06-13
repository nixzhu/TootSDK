// Created by TootSDK contributors.
// Copyright (c) 2025. All rights reserved.

import Foundation

/// Represents the authenticated user's profile, as returned by the /api/v1/profile endpoint.
public struct Profile: Codable, Hashable, Identifiable, Sendable {

    /// The internal ID of the profile in the database.
    public var id: String

    /// The profile's display name.
    public var displayName: String?

    /// The profile's bio / description (raw text).
    public var note: String?

    /// The profile's bio / description rendered as HTML.
    public var formattedNote: String?

    /// Profile fields (raw values).
    public var fields: [TootField]

    /// Profile fields with HTML-rendered values.
    public var formattedFields: [TootField]

    /// URL of the avatar image.
    public var avatar: String?

    /// URL of a static variant of the avatar image.
    public var avatarStatic: String?

    /// Alternative text for the avatar image.
    public var avatarDescription: String?

    /// URL of the header image.
    public var header: String?

    /// URL of a static variant of the header image.
    public var headerStatic: String?

    /// Alternative text for the header image.
    public var headerDescription: String?

    /// Whether manual approval of follow requests is required.
    public var locked: Bool?

    /// Whether the account has a bot flag.
    public var bot: Bool?

    /// Whether followers and followed accounts are hidden.
    public var hideCollections: Bool?

    /// Whether the account appears in the profile directory.
    public var discoverable: Bool?

    /// Whether public posts are searchable to anyone.
    public var indexable: Bool?

    /// Whether media attachments are shown by default.
    public var showMedia: Bool?

    /// Whether media attachments in replies are shown by default.
    public var showMediaReplies: Bool?

    /// Whether featured posts are shown on the profile.
    public var showFeatured: Bool?

    /// Domains of websites allowed to credit the account in link preview cards.
    public var attributionDomains: [String]?

    /// Hashtags featured on the profile.
    public var featuredTags: [FeaturedTag]?

    public init(
        id: String,
        displayName: String? = nil,
        note: String? = nil,
        formattedNote: String? = nil,
        fields: [TootField] = [],
        formattedFields: [TootField] = [],
        avatar: String? = nil,
        avatarStatic: String? = nil,
        avatarDescription: String? = nil,
        header: String? = nil,
        headerStatic: String? = nil,
        headerDescription: String? = nil,
        locked: Bool? = nil,
        bot: Bool? = nil,
        hideCollections: Bool? = nil,
        discoverable: Bool? = nil,
        indexable: Bool? = nil,
        showMedia: Bool? = nil,
        showMediaReplies: Bool? = nil,
        showFeatured: Bool? = nil,
        attributionDomains: [String]? = nil,
        featuredTags: [FeaturedTag]? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.note = note
        self.formattedNote = formattedNote
        self.fields = fields
        self.formattedFields = formattedFields
        self.avatar = avatar
        self.avatarStatic = avatarStatic
        self.avatarDescription = avatarDescription
        self.header = header
        self.headerStatic = headerStatic
        self.headerDescription = headerDescription
        self.locked = locked
        self.bot = bot
        self.hideCollections = hideCollections
        self.discoverable = discoverable
        self.indexable = indexable
        self.showMedia = showMedia
        self.showMediaReplies = showMediaReplies
        self.showFeatured = showFeatured
        self.attributionDomains = attributionDomains
        self.featuredTags = featuredTags
    }

    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case note
        case formattedNote
        case fields
        case formattedFields
        case avatar
        case avatarStatic
        case avatarDescription
        case header
        case headerStatic
        case headerDescription
        case locked
        case bot
        case hideCollections
        case discoverable
        case indexable
        case showMedia
        case showMediaReplies
        case showFeatured
        case attributionDomains
        case featuredTags
    }
}
