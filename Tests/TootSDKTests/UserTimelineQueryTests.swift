//  UserTimelineQueryTests.swift

import XCTest

@testable import TootSDK

final class UserTimelineQueryTests: XCTestCase {

    func testExcludeDirectAppearsInQueryItems() {
        // arrange
        let query = UserTimelineQuery(userId: "1", excludeDirect: true)

        // act
        let items = query.getQueryItems()

        // assert
        XCTAssertTrue(items.contains(URLQueryItem(name: "exclude_direct", value: "true")))
    }

    func testExcludeDirectOmittedWhenNil() {
        // arrange
        let query = UserTimelineQuery(userId: "1")

        // act
        let items = query.getQueryItems()

        // assert
        XCTAssertFalse(items.contains(where: { $0.name == "exclude_direct" }))
    }
}
