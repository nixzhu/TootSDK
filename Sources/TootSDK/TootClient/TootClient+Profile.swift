// Created by TootSDK contributors.
// Copyright (c) 2025. All rights reserved.

import Foundation
import MultipartKitTootSDK

extension TootClient {

    /// Retrieves the authenticated user's profile.
    ///
    /// - Returns: The user's profile, or throws an error if unable to retrieve.
    /// - Note: Requires profile feature to be available.
    public func getProfile() async throws -> Profile {
        let response = try await getProfileRaw()
        return response.data
    }

    /// Retrieves the authenticated user's profile with HTTP response metadata.
    ///
    /// - Returns: TootResponse containing the user's profile and HTTP metadata.
    /// - Note: Requires profile feature to be available.
    public func getProfileRaw() async throws -> TootResponse<Profile> {
        try requireFeature(.profile)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "profile"])
            $0.method = .get
        }
        return try await fetchRaw(Profile.self, req)
    }

    /// Updates the authenticated user's profile.
    ///
    /// - Parameter params: The profile fields to update.
    /// - Returns: The updated profile.
    /// - Note: Requires profile feature to be available.
    @discardableResult
    public func updateProfile(params: UpdateProfileParams) async throws -> Profile {
        let response = try await updateProfileRaw(params: params)
        return response.data
    }

    /// Updates the authenticated user's profile with HTTP response metadata.
    ///
    /// - Parameter params: The profile fields to update.
    /// - Returns: TootResponse containing the updated profile and HTTP metadata.
    /// - Note: Requires profile feature to be available.
    @discardableResult
    public func updateProfileRaw(params: UpdateProfileParams) async throws -> TootResponse<Profile> {
        try requireFeature(.profile)
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "profile"])
            $0.method = .patch
            var parts = [MultipartPart]()
            if let data = params.avatar,
                let mimeType = params.avatarMimeType
            {
                parts.append(
                    MultipartPart(
                        file: "avatar",
                        mimeType: mimeType,
                        body: data))
            }
            if let data = params.header,
                let mimeType = params.headerMimeType
            {
                parts.append(
                    MultipartPart(
                        file: "header",
                        mimeType: mimeType,
                        body: data))
            }
            if let displayName = params.displayName {
                parts.append(
                    MultipartPart(name: "display_name", body: displayName))
            }
            if let note = params.note {
                parts.append(
                    MultipartPart(name: "note", body: note))
            }
            if let avatarDescription = params.avatarDescription {
                parts.append(
                    MultipartPart(name: "avatar_description", body: avatarDescription))
            }
            if let headerDescription = params.headerDescription {
                parts.append(
                    MultipartPart(name: "header_description", body: headerDescription))
            }
            if let locked = params.locked {
                parts.append(
                    MultipartPart(name: "locked", body: String(locked)))
            }
            if let bot = params.bot {
                parts.append(
                    MultipartPart(name: "bot", body: String(bot)))
            }
            if let discoverable = params.discoverable {
                parts.append(
                    MultipartPart(name: "discoverable", body: String(discoverable)))
            }
            if let hideCollections = params.hideCollections {
                parts.append(
                    MultipartPart(name: "hide_collections", body: String(hideCollections)))
            }
            if let indexable = params.indexable {
                parts.append(
                    MultipartPart(name: "indexable", body: String(indexable)))
            }
            if let showMedia = params.showMedia {
                parts.append(
                    MultipartPart(name: "show_media", body: String(showMedia)))
            }
            if let showMediaReplies = params.showMediaReplies {
                parts.append(
                    MultipartPart(name: "show_media_replies", body: String(showMediaReplies)))
            }
            if let showFeatured = params.showFeatured {
                parts.append(
                    MultipartPart(name: "show_featured", body: String(showFeatured)))
            }
            if let domains = params.attributionDomains {
                for domain in domains {
                    parts.append(
                        MultipartPart(name: "attribution_domains[]", body: domain))
                }
            }
            if let fields = params.fieldsAttributes {
                for (key, field) in fields {
                    parts.append(
                        MultipartPart(name: "fields_attributes[\(key)][name]", body: field.name))
                    parts.append(
                        MultipartPart(name: "fields_attributes[\(key)][value]", body: field.value))
                }
            }
            $0.body = try .multipart(parts, boundary: UUID().uuidString)
        }
        return try await fetchRaw(Profile.self, req)
    }
}

extension TootFeature {

    /// Ability to get and update the user's profile via /api/v1/profile.
    ///
    public static let profile = TootFeature(requirements: [
        .from(.mastodon, version: 10, fallbackDisplayVersion: "4.6.0")
    ])
}
