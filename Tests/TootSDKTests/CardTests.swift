//
//  CardTests.swift
//  TootSDK
//
//  Created by Łukasz Rutkowski on 15/11/2024.
//

import Foundation
import XCTest

@testable import TootSDK

final class CardTests: XCTestCase {
    func testDecodeCard() throws {
        let json = localContent("card_string_size")
        let decoder = TootDecoder()

        let result = try decoder.decode(Card.self, from: json)

        XCTAssertNotNil(result)
        XCTAssertEqual(result.title, "Example")
        XCTAssertEqual(result.width, 520)
        XCTAssertEqual(result.height, 347)
    }

    func testDecodeMissingAttribution() throws {
        // arrange
        let json = localContent("card_missing_attribution")
        let decoder = TootDecoder()

        // act
        let result = try decoder.decode(Card.self, from: json)

        // assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.title, "Example Article")
        XCTAssertEqual(result.missingAttribution, true)
    }
}
