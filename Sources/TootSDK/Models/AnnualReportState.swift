//
//  AnnualReportState.swift
//  TootSDK
//

import Foundation

/// The availability state of an annual report for a given year.
public struct AnnualReportState: Codable, Hashable, Sendable {

    /// The current state of the annual report.
    public var state: OpenEnum<State>

    /// Possible states for an annual report.
    public enum State: String, Codable, Hashable, Sendable {
        /// A generated report is available for the account.
        case available
        /// The report is currently being generated in the background.
        case generating
        /// The account is eligible for a report but generation has not started.
        case eligible
        /// The account is not eligible for a report this year.
        case ineligible
    }
}
