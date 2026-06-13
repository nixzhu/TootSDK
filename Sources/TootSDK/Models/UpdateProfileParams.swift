// Created by TootSDK contributors.
// Copyright (c) 2025. All rights reserved.

import Foundation

/// Parameters for updating the authenticated user's profile via PATCH /api/v1/profile.
public struct UpdateProfileParams: Codable {

    /// The display name to use for the profile.
    public var displayName: String?

    /// The account bio.
    public var note: String?

    /// Avatar image encoded using multipart/form-data.
    public var avatar: Data?

    public var avatarMimeType: String?

    /// Alternative text for the avatar image.
    public var avatarDescription: String?

    /// Header image encoded using multipart/form-data.
    public var header: Data?

    public var headerMimeType: String?

    /// Alternative text for the header image.
    public var headerDescription: String?

    /// Whether manual approval of follow requests is required.
    public var locked: Bool?

    /// Whether the account has a bot flag.
    public var bot: Bool?

    /// Whether the account should be shown in the profile directory.
    public var discoverable: Bool?

    /// Whether to hide followers and followed accounts.
    public var hideCollections: Bool?

    /// Whether public posts should be searchable to anyone.
    public var indexable: Bool?

    /// Whether media attachments are shown by default.
    public var showMedia: Bool?

    /// Whether media attachments in replies are shown by default.
    public var showMediaReplies: Bool?

    /// Whether featured posts are shown on the profile.
    public var showFeatured: Bool?

    /// Domains of websites allowed to credit the account in link preview cards.
    public var attributionDomains: [String]?

    /// Additional metadata attached to a profile as name-value pairs.
    public var fieldsAttributes: [String: Field]?

    public init(
        displayName: String? = nil,
        note: String? = nil,
        avatar: Data? = nil,
        avatarMimeType: String? = nil,
        avatarDescription: String? = nil,
        header: Data? = nil,
        headerMimeType: String? = nil,
        headerDescription: String? = nil,
        locked: Bool? = nil,
        bot: Bool? = nil,
        discoverable: Bool? = nil,
        hideCollections: Bool? = nil,
        indexable: Bool? = nil,
        showMedia: Bool? = nil,
        showMediaReplies: Bool? = nil,
        showFeatured: Bool? = nil,
        attributionDomains: [String]? = nil,
        fieldsAttributes: [String: Field]? = nil
    ) {
        self.displayName = displayName
        self.note = note
        self.avatar = avatar
        self.avatarMimeType = avatarMimeType
        self.avatarDescription = avatarDescription
        self.header = header
        self.headerMimeType = headerMimeType
        self.headerDescription = headerDescription
        self.locked = locked
        self.bot = bot
        self.discoverable = discoverable
        self.hideCollections = hideCollections
        self.indexable = indexable
        self.showMedia = showMedia
        self.showMediaReplies = showMediaReplies
        self.showFeatured = showFeatured
        self.attributionDomains = attributionDomains
        self.fieldsAttributes = fieldsAttributes
    }

    /// Represents a profile field as a name-value pair.
    public struct Field: Codable, Hashable, Sendable {
        /// The key of a given field's key-value pair.
        public var name: String
        /// The value associated with the name key.
        public var value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}
