import Version
import XCTest

@testable import TootSDK

final class ProfileTests: XCTestCase {

    // MARK: - Decoding

    func testDecoding() throws {
        let profile = try localObject(Profile.self, "profile")

        XCTAssertEqual(profile.id, "110224456721299440")
        XCTAssertEqual(profile.displayName, "Alice Example")
    }

    func testDecodingRawVsFormattedNote() throws {
        let profile = try localObject(Profile.self, "profile")

        XCTAssertEqual(profile.note, "An example bio with a link https://example.com")
        XCTAssertEqual(
            profile.formattedNote,
            "<p>An example bio with a link <a href=\"https://example.com\">https://example.com</a></p>"
        )
        XCTAssertNotEqual(profile.note, profile.formattedNote)
    }

    func testDecodingRawVsFormattedFields() throws {
        let profile = try localObject(Profile.self, "profile")

        XCTAssertEqual(profile.fields.count, 2)
        XCTAssertEqual(profile.formattedFields.count, 2)

        let rawWebsite = try XCTUnwrap(profile.fields.first(where: { $0.name == "Website" }))
        let formattedWebsite = try XCTUnwrap(profile.formattedFields.first(where: { $0.name == "Website" }))

        XCTAssertEqual(rawWebsite.value, "https://example.com")
        XCTAssertTrue(formattedWebsite.value.contains("<a href="))
        XCTAssertNotNil(formattedWebsite.verifiedAt)
        XCTAssertNil(rawWebsite.verifiedAt)
    }

    func testDecodingShowFlags() throws {
        let profile = try localObject(Profile.self, "profile")

        XCTAssertEqual(profile.showMedia, true)
        XCTAssertEqual(profile.showMediaReplies, false)
        XCTAssertEqual(profile.showFeatured, true)
    }

    func testDecodingAttributionDomains() throws {
        let profile = try localObject(Profile.self, "profile")

        let domains = try XCTUnwrap(profile.attributionDomains)
        XCTAssertEqual(domains.count, 2)
        XCTAssertTrue(domains.contains("example.com"))
        XCTAssertTrue(domains.contains("blog.example.com"))
    }

    func testDecodingAvatarAndHeaderDescriptions() throws {
        let profile = try localObject(Profile.self, "profile")

        XCTAssertEqual(profile.avatarDescription, "A cartoon cat in a hat")
        XCTAssertEqual(profile.headerDescription, "A scenic mountain landscape")
        XCTAssertNotNil(profile.avatarStatic)
        XCTAssertNotNil(profile.headerStatic)
    }

    func testDecodingFeaturedTags() throws {
        let profile = try localObject(Profile.self, "profile")

        let tags = try XCTUnwrap(profile.featuredTags)
        XCTAssertEqual(tags.count, 1)
        XCTAssertEqual(tags[0].id, "384027")
        XCTAssertEqual(tags[0].name, "swift")
    }

    func testDecodingBooleanFlags() throws {
        let profile = try localObject(Profile.self, "profile")

        XCTAssertEqual(profile.locked, false)
        XCTAssertEqual(profile.bot, false)
        XCTAssertEqual(profile.hideCollections, false)
        XCTAssertEqual(profile.discoverable, true)
        XCTAssertEqual(profile.indexable, false)
    }

    // MARK: - Feature gate

    func testProfileFeatureSupportedAtApiVersion10() {
        let feature = TootFeature.profile
        let apiVersions = InstanceV2.APIVersions(mastodon: 10)
        XCTAssertTrue(feature.isSupported(flavour: .mastodon, version: nil, apiVersions: apiVersions))
    }

    func testProfileFeatureUnsupportedAtApiVersion9() {
        let feature = TootFeature.profile
        let apiVersions = InstanceV2.APIVersions(mastodon: 9)
        XCTAssertFalse(feature.isSupported(flavour: .mastodon, version: nil, apiVersions: apiVersions))
    }

    func testProfileFeatureFallbackDisplayVersion() {
        let feature = TootFeature.profile
        let version460 = Version(tolerant: "4.6.0")
        XCTAssertTrue(feature.isSupported(flavour: .mastodon, version: version460, apiVersions: nil))
    }

    func testProfileFeatureFallbackDisplayVersionTooLow() {
        let feature = TootFeature.profile
        let version450 = Version(tolerant: "4.5.0")
        XCTAssertFalse(feature.isSupported(flavour: .mastodon, version: version450, apiVersions: nil))
    }

    func testProfileFeatureUnsupportedOnOtherFlavours() {
        let feature = TootFeature.profile
        XCTAssertFalse(feature.isSupported(flavour: .pixelfed, version: nil as Version?))
        XCTAssertFalse(feature.isSupported(flavour: .pleroma, version: nil as Version?))
        XCTAssertFalse(feature.isSupported(flavour: .akkoma, version: nil as Version?))
    }
}
