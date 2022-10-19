//
//  HomeModelTest.swift
//  SocialAppTests
//
//  Created by William Huang on 20/10/22.
//

import XCTest
@testable import SocialApp

class HomeModelTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetFirstName() {
        // Given
        let user = User(id: "user-1", profileImagePath: "dummy", firstName: "William", lastName: nil)
        // Then
        XCTAssertEqual(user.fullName, "William")
    }

    func testGetLastName() {
        // Given
        let user = User(id: "user-1", profileImagePath: "dummy", firstName: nil, lastName: "Huang")
        // Then
        XCTAssertEqual(user.fullName, "Huang")
    }

    func testGetFullName() {
        // Given
        let user = User(id: "user-1", profileImagePath: "dummy", firstName: "William", lastName: "Huang")
        // Then
        XCTAssertEqual(user.fullName, "William Huang")
    }

    func testFailGetFullName() {
        // Given
        let user = User(id: "user-1", profileImagePath: "dummy", firstName: nil, lastName: nil)
        // Then
        XCTAssertEqual(user.fullName, "unknown")
    }

}
