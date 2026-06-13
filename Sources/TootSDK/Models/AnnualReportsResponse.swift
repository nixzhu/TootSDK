//
//  AnnualReportsResponse.swift
//  TootSDK
//

import Foundation

/// The wrapper returned by the annual reports index and show endpoints,
/// containing reports alongside the accounts and statuses they reference.
public struct AnnualReportsResponse: Codable, Hashable, Sendable {

    /// The annual reports included in this response.
    public var annualReports: [AnnualReport]

    /// Accounts referenced by the reports (e.g. most-interacted accounts).
    public var accounts: [Account]

    /// Statuses referenced by ``AnnualReport/Data/TopStatuses``.
    public var statuses: [Post]

    public enum CodingKeys: String, CodingKey {
        case annualReports
        case accounts
        case statuses
    }
}
