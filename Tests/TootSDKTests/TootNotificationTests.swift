//
//  TootNotificationTests.swift
//
//
//  Created by Konstantin Kostov on 13/06/2025.
//

import Foundation
import Testing

@testable import TootSDK

@Suite struct TootNotificationTests {

    @Test func addedToCollectionRawValueRoundTrip() {
        #expect(TootNotification.NotificationType(rawValue: "added_to_collection") == .addedToCollection)
        #expect(TootNotification.NotificationType.addedToCollection.rawValue == "added_to_collection")
    }

    @Test func collectionUpdateRawValueRoundTrip() {
        #expect(TootNotification.NotificationType(rawValue: "collection_update") == .collectionUpdate)
        #expect(TootNotification.NotificationType.collectionUpdate.rawValue == "collection_update")
    }

    @Test func newTypesInAllCases() {
        let allCases = TootNotification.NotificationType.allCases
        #expect(allCases.contains(.addedToCollection))
        #expect(allCases.contains(.collectionUpdate))
    }

    @Test func newTypesSupportedByMastodon() {
        let supported = TootNotification.NotificationType.supported(by: .mastodon)
        #expect(supported.contains(.addedToCollection))
        #expect(supported.contains(.collectionUpdate))
    }

    @Test func decodeAddedToCollectionNotification() throws {
        let json = localContent("notification_added_to_collection")
        let decoder = TootDecoder()

        let notification = try decoder.decode(TootNotification.self, from: json)

        #expect(notification.type == .addedToCollection)
        let collection = try #require(notification.collection)
        #expect(collection.id == "42")
        #expect(collection.name == "Swift Developers")
    }

    @Test func decodeFallbackNotification() throws {
        let json = localContent("notification_with_fallback")
        let decoder = TootDecoder()

        let notification = try decoder.decode(TootNotification.self, from: json)

        #expect(notification.type == .unknown("some_future_type"))
        let fallback = try #require(notification.fallback)
        #expect(fallback.title == "Notification")
        #expect(fallback.summary == "Something happened")
    }

    @Test func supportedTypesQueryParam() throws {
        let client = TootClient(
            instanceURL: URL(string: "https://mastodon.social")!,
            serverConfiguration: ServerConfiguration(flavour: .mastodon)
        )

        let params = TootNotificationParams(supportedTypes: [.addedToCollection, .collectionUpdate])
        let query = client.createQuery(from: params).sorted { ($0.name, $0.value ?? "") < ($1.name, $1.value ?? "") }

        #expect(
            query == [
                URLQueryItem(name: "supported_types[]", value: "added_to_collection"),
                URLQueryItem(name: "supported_types[]", value: "collection_update"),
            ])
    }
}
