import Version
import XCTest

@testable import TootSDK

final class CollectionTests: XCTestCase {

    func testCollectionDecode() throws {
        let json = localContent("collection")
        let decoder = TootDecoder()

        let result = try decoder.decode(Collection.self, from: json)

        XCTAssertEqual(result.id, "42")
        XCTAssertEqual(result.uri, "https://mastodon.example/collections/42")
        XCTAssertEqual(result.url, "https://mastodon.example/@alice/collections/42")
        XCTAssertEqual(result.name, "Swift Developers")
        XCTAssertEqual(result.description, "A collection of Swift developers.")
        XCTAssertEqual(result.language, "en")
        XCTAssertEqual(result.accountId, "101")
        XCTAssertEqual(result.local, true)
        XCTAssertEqual(result.sensitive, false)
        XCTAssertEqual(result.discoverable, true)
        XCTAssertEqual(result.itemCount, 2)
        XCTAssertNotNil(result.createdAt)
        XCTAssertNotNil(result.updatedAt)
        XCTAssertEqual(result.tag?.name, "swift")
        XCTAssertEqual(result.items?.count, 2)
    }

    func testCollectionItemDecode() throws {
        let json = localContent("collection")
        let decoder = TootDecoder()

        let collection = try decoder.decode(Collection.self, from: json)

        let items = try XCTUnwrap(collection.items)
        XCTAssertEqual(items.count, 2)

        let accepted = items[0]
        XCTAssertEqual(accepted.id, "1")
        XCTAssertEqual(accepted.state, .some(.accepted))
        XCTAssertEqual(accepted.accountId, "201")
        XCTAssertNotNil(accepted.createdAt)

        let pending = items[1]
        XCTAssertEqual(pending.id, "2")
        XCTAssertEqual(pending.state, .some(.pending))
    }

    func testCollectionItemUnknownStateDecode() throws {
        let json = Data(
            """
            {"id":"99","state":"something_new","account_id":"300","created_at":"2024-01-01T00:00:00.000Z"}
            """.utf8)
        let decoder = TootDecoder()

        let item = try decoder.decode(CollectionItem.self, from: json)

        XCTAssertEqual(item.id, "99")
        if case .unparsedByTootSDK(let raw) = item.state {
            XCTAssertEqual(raw, "something_new")
        } else {
            XCTFail("Expected unparsedByTootSDK state")
        }
    }

    func testCollectionWithAccountsDecode() throws {
        let json = localContent("collection_with_accounts")
        let decoder = TootDecoder()

        let result = try decoder.decode(CollectionWithAccounts.self, from: json)

        XCTAssertEqual(result.collection.id, "42")
        XCTAssertEqual(result.collection.name, "Swift Developers")
        XCTAssertEqual(result.collection.itemCount, 1)
        XCTAssertEqual(result.accounts.count, 1)
        XCTAssertEqual(result.accounts[0].id, "201")
        XCTAssertEqual(result.accounts[0].username, "swiftdev")
    }

    func testCollectionsFeatureGate() throws {
        let apiVersions10 = InstanceV2.APIVersions(mastodon: 10)
        XCTAssertTrue(TootFeature.collections.isSupported(flavour: .mastodon, version: nil, apiVersions: apiVersions10))

        let apiVersions9 = InstanceV2.APIVersions(mastodon: 9)
        XCTAssertFalse(TootFeature.collections.isSupported(flavour: .mastodon, version: nil, apiVersions: apiVersions9))

        let apiVersions11 = InstanceV2.APIVersions(mastodon: 11)
        XCTAssertTrue(TootFeature.collections.isSupported(flavour: .mastodon, version: nil, apiVersions: apiVersions11))
    }

    func testCollectionsFeatureGateFallbackDisplayVersion() throws {
        let version460 = Version(tolerant: "4.6.0")
        XCTAssertTrue(TootFeature.collections.isSupported(flavour: .mastodon, version: version460, apiVersions: nil))

        let version450 = Version(tolerant: "4.5.0")
        XCTAssertFalse(TootFeature.collections.isSupported(flavour: .mastodon, version: version450, apiVersions: nil))
    }

    func testCollectionsListWrappedDecode() throws {
        let json = localContent("collections_list")
        let decoder = TootDecoder()

        let container = try decoder.decode(CollectionsListContainer.self, from: json)

        XCTAssertEqual(container.collections.count, 2)
        XCTAssertEqual(container.collections[0].id, "42")
        XCTAssertEqual(container.collections[0].name, "Swift Developers")
        XCTAssertEqual(container.collections[0].itemCount, 2)
        XCTAssertEqual(container.collections[1].id, "99")
        XCTAssertEqual(container.collections[1].name, "Designers")
    }

    func testCollectionCreateResponseWrappedDecode() throws {
        let json = localContent("collection_create_response")
        let decoder = TootDecoder()

        let container = try decoder.decode(CollectionContainer.self, from: json)
        let collection = container.collection

        XCTAssertEqual(collection.id, "55")
        XCTAssertEqual(collection.name, "iOS Engineers")
        XCTAssertEqual(collection.accountId, "101")
        XCTAssertEqual(collection.discoverable, false)
        XCTAssertEqual(collection.itemCount, 0)
    }

    func testCollectionItemResponseWrappedDecode() throws {
        let json = localContent("collection_item_response")
        let decoder = TootDecoder()

        let container = try decoder.decode(CollectionItemContainer.self, from: json)
        let item = container.collectionItem

        XCTAssertEqual(item.id, "77")
        XCTAssertEqual(item.state, .some(.pending))
        XCTAssertEqual(item.accountId, "303")
        XCTAssertNotNil(item.createdAt)
    }
}
