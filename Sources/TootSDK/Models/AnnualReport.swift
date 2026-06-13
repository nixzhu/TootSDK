//
//  AnnualReport.swift
//  TootSDK
//

import Foundation

/// A generated annual report ("Wrapstodon") for an account, including the full data payload
/// and references to accounts and statuses hydrated in the enclosing response.
public struct AnnualReport: Codable, Hashable, Sendable, Identifiable {

    /// The year this report covers.
    public var year: Int

    /// The schema version of the report data.
    public var schemaVersion: Int

    /// A public share URL for the report, if a share key has been generated.
    public var shareUrl: String?

    /// The ID of the account this report belongs to.
    public var accountId: String

    /// The computed report payload, merged from all data sources.
    public var data: Data

    public var id: String { "\(accountId)-\(year)" }

    public enum CodingKeys: String, CodingKey {
        case year
        case schemaVersion
        case shareUrl
        case accountId
        case data
    }

    /// The merged payload produced by all annual report data sources.
    public struct Data: Codable, Hashable, Sendable {

        /// The behavioral archetype assigned to the account for the year.
        public var archetype: OpenEnum<Archetype>?

        /// The top statuses by engagement for the year.
        public var topStatuses: TopStatuses?

        /// The top hashtags used during the year.
        public var topHashtags: [Hashtag]?

        /// Monthly activity breakdown for the year.
        public var timeSeries: [TimeSeriesEntry]?

        public enum CodingKeys: String, CodingKey {
            case archetype
            case topStatuses
            case topHashtags
            case timeSeries
        }

        /// Behavioral archetype assigned based on posting patterns.
        public enum Archetype: String, Codable, Hashable, Sendable {
            /// Posts infrequently relative to the average active user.
            case lurker
            /// Reblogs far more than posting original content.
            case booster
            /// Frequently uses polls in posts.
            case pollster
            /// Replies to others far more than posting original content.
            case replier
            /// Posts original content regularly at a healthy volume.
            case oracle
        }

        /// Top statuses by engagement metric, referencing status IDs
        /// that are hydrated in the enclosing ``AnnualReportsResponse``.
        public struct TopStatuses: Codable, Hashable, Sendable {
            /// ID of the status with the most reblogs.
            public var byReblogs: String?
            /// ID of the status with the most favourites.
            public var byFavourites: String?
            /// ID of the status with the most replies.
            public var byReplies: String?

            public enum CodingKeys: String, CodingKey {
                case byReblogs
                case byFavourites
                case byReplies
            }
        }

        /// A hashtag and the number of times it was used during the year.
        public struct Hashtag: Codable, Hashable, Sendable {
            /// The hashtag name without the leading `#`.
            public var name: String
            /// Number of times the hashtag was used.
            public var count: Int
        }

        /// Status and follower counts for a single month.
        public struct TimeSeriesEntry: Codable, Hashable, Sendable {
            /// The calendar month number (1–12).
            public var month: Int
            /// Number of statuses posted during this month.
            public var statuses: Int
            /// Number of followers gained during this month.
            public var followers: Int
        }
    }
}
