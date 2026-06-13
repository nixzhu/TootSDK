//
//  TootClient+AnnualReports.swift
//  TootSDK
//

import Foundation

extension TootClient {

    /// Returns all unread annual reports for the authenticated account.
    public func getAnnualReports() async throws -> AnnualReportsResponse {
        let response = try await getAnnualReportsRaw()
        return response.data
    }

    /// Returns all unread annual reports for the authenticated account with HTTP response metadata.
    public func getAnnualReportsRaw() async throws -> TootResponse<AnnualReportsResponse> {
        try requireFeature(.annualReports)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "annual_reports"])
            $0.method = .get
        }
        return try await fetchRaw(AnnualReportsResponse.self, req)
    }

    /// Returns the annual report for the given year.
    /// - Parameter year: The four-digit year of the report.
    public func getAnnualReport(year: Int) async throws -> AnnualReportsResponse {
        let response = try await getAnnualReportRaw(year: year)
        return response.data
    }

    /// Returns the annual report for the given year with HTTP response metadata.
    /// - Parameter year: The four-digit year of the report.
    public func getAnnualReportRaw(year: Int) async throws -> TootResponse<AnnualReportsResponse> {
        try requireFeature(.annualReports)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "annual_reports", String(year)])
            $0.method = .get
        }
        return try await fetchRaw(AnnualReportsResponse.self, req)
    }

    /// Returns the availability state of an annual report for the given year.
    /// - Parameter year: The four-digit year to query.
    public func getAnnualReportState(year: Int) async throws -> AnnualReportState {
        let response = try await getAnnualReportStateRaw(year: year)
        return response.data
    }

    /// Returns the availability state of an annual report for the given year with HTTP response metadata.
    /// - Parameter year: The four-digit year to query.
    public func getAnnualReportStateRaw(year: Int) async throws -> TootResponse<AnnualReportState> {
        try requireFeature(.annualReports)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "annual_reports", String(year), "state"])
            $0.method = .get
        }
        return try await fetchRaw(AnnualReportState.self, req)
    }

    /// Marks an annual report as read.
    /// - Parameter year: The four-digit year of the report to mark as read.
    public func markAnnualReportRead(year: Int) async throws {
        try requireFeature(.annualReports)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "annual_reports", String(year), "read"])
            $0.method = .post
        }
        _ = try await fetch(req: req)
    }

    /// Triggers server-side generation of an annual report for the given year.
    ///
    /// The server responds with HTTP 202 and a `Mastodon-Async-Refresh` header.
    /// Poll the returned hint's ID via ``TootClient/_getAsyncRefresh(id:)`` to track progress,
    /// waiting at least ``_AsyncRefreshHint/retry`` seconds between polls.
    ///
    /// - Parameter year: The four-digit year for which to generate the report.
    /// - Returns: An ``_AsyncRefreshHint`` if the server returned one, or `nil` if the
    ///   report already exists or generation is not available for the given year.
    @discardableResult
    public func generateAnnualReport(year: Int) async throws -> _AsyncRefreshHint? {
        let response = try await generateAnnualReportRaw(year: year)
        return response.asyncRefresh
    }

    /// Triggers server-side generation of an annual report for the given year,
    /// returning the raw HTTP response so callers can inspect the status code and headers.
    ///
    /// - Parameter year: The four-digit year for which to generate the report.
    /// - Returns: A ``TootResponse`` wrapping an empty payload. Inspect ``TootResponse/asyncRefresh``
    ///   to obtain the async refresh hint.
    @discardableResult
    public func generateAnnualReportRaw(year: Int) async throws -> TootResponse<Void> {
        try requireFeature(.annualReports)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "annual_reports", String(year), "generate"])
            $0.method = .post
        }
        let (data, response) = try await fetch(req: req)
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields {
            if let keyString = key as? String, let valueString = value as? String {
                headers[keyString] = valueString
            }
        }
        return TootResponse(
            data: (),
            headers: headers,
            statusCode: response.statusCode,
            url: response.url,
            rawBody: data
        )
    }
}

extension TootFeature {
    /// Ability to read and generate annual reports ("Wrapstodon"), available from Mastodon API version 10.
    public static let annualReports = TootFeature(requirements: [
        .from(.mastodon, version: 10, fallbackDisplayVersion: "4.6.0")
    ])
}
