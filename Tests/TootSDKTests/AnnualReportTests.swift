//
//  AnnualReportTests.swift
//  TootSDK
//

import XCTest

@testable import TootSDK

final class AnnualReportTests: XCTestCase {

    // MARK: - AnnualReportsResponse decoding

    func testDecodeAnnualReportsResponse() throws {
        let result = try localObject(AnnualReportsResponse.self, "annual_report")

        XCTAssertEqual(result.annualReports.count, 1)
        XCTAssertEqual(result.statuses.count, 1)
        XCTAssertEqual(result.accounts.count, 0)
    }

    func testDecodeAnnualReportFields() throws {
        let result = try localObject(AnnualReportsResponse.self, "annual_report")
        let report = try XCTUnwrap(result.annualReports.first)

        XCTAssertEqual(report.year, 2024)
        XCTAssertEqual(report.schemaVersion, 2)
        XCTAssertEqual(report.accountId, "123456789")
        XCTAssertEqual(report.shareUrl, "https://mastodon.example/wrapstodon/@alice/2024/abc123def456")
    }

    // MARK: - Data sub-struct decoding

    func testDecodeAnnualReportArchetype() throws {
        let result = try localObject(AnnualReportsResponse.self, "annual_report")
        let data = try XCTUnwrap(result.annualReports.first).data

        XCTAssertEqual(data.archetype, .some(.oracle))
    }

    func testDecodeAnnualReportTopStatuses() throws {
        let result = try localObject(AnnualReportsResponse.self, "annual_report")
        let data = try XCTUnwrap(result.annualReports.first).data
        let topStatuses = try XCTUnwrap(data.topStatuses)

        XCTAssertEqual(topStatuses.byReblogs, "112345678901234567")
        XCTAssertNil(topStatuses.byFavourites)
        XCTAssertNil(topStatuses.byReplies)
    }

    func testDecodeAnnualReportTopHashtags() throws {
        let result = try localObject(AnnualReportsResponse.self, "annual_report")
        let data = try XCTUnwrap(result.annualReports.first).data
        let hashtags = try XCTUnwrap(data.topHashtags)

        XCTAssertEqual(hashtags.count, 1)
        XCTAssertEqual(hashtags.first?.name, "swift")
        XCTAssertEqual(hashtags.first?.count, 12)
    }

    func testDecodeAnnualReportTimeSeries() throws {
        let result = try localObject(AnnualReportsResponse.self, "annual_report")
        let data = try XCTUnwrap(result.annualReports.first).data
        let timeSeries = try XCTUnwrap(data.timeSeries)

        XCTAssertEqual(timeSeries.count, 1)
        let entry = try XCTUnwrap(timeSeries.first)
        XCTAssertEqual(entry.month, 12)
        XCTAssertEqual(entry.statuses, 47)
        XCTAssertEqual(entry.followers, 5)
    }

    // MARK: - AnnualReportState decoding

    func testDecodeAnnualReportStateAvailable() throws {
        let result = try localObject(AnnualReportState.self, "annual_report_state")

        XCTAssertEqual(result.state, .some(.available))
    }

    func testDecodeAnnualReportStateUnknown() throws {
        let json = Data(#"{"state":"future_value"}"#.utf8)
        let decoder = TootDecoder()
        let result = try decoder.decode(AnnualReportState.self, from: json)

        XCTAssertEqual(result.state, .unparsedByTootSDK(rawValue: "future_value"))
    }

    // MARK: - Feature gate

    func testAnnualReportsFeatureRequiresApiVersion10() throws {
        let instance10 = InstanceV2(
            version: "4.6.0",
            registrations: InstanceV2.Registrations(),
            apiVersions: InstanceV2.APIVersions(mastodon: 10)
        )
        XCTAssertTrue(TootFeature.annualReports.isSupported(by: instance10))

        let instance9 = InstanceV2(
            version: "4.5.0",
            registrations: InstanceV2.Registrations(),
            apiVersions: InstanceV2.APIVersions(mastodon: 9)
        )
        XCTAssertFalse(TootFeature.annualReports.isSupported(by: instance9))
    }

    func testAnnualReportsFeatureFallsBackToDisplayVersion() throws {
        let feature = TootFeature.annualReports

        XCTAssertTrue(feature.isSupported(flavour: .mastodon, version: "4.6.0"))
        XCTAssertFalse(feature.isSupported(flavour: .mastodon, version: "4.5.9"))
    }
}
