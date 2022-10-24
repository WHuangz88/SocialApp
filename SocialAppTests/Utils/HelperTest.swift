//
//  HelperTest.swift
//  SocialAppTests
//
//  Created by William Huang on 24/10/22.
//

import XCTest
@testable import SocialApp

class StringHelperTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNormalFormat() {
        // Given
        let sample = "2022-08-07T17:36:58.516Z"
        // When
        let output = sample.convertDate(toFormat: .normal)
        // Then
        XCTAssertEqual(output, "07-08-22 17:36")
    }

    func testDetectLinks() {
        // Given
        let noLinkText = "Hello my name is SocialApp"
        let noLinkTextView = UITextView()
        noLinkTextView.text = noLinkText

        let linkText = "www.google.com"
        let linkTextView = UITextView()
        linkTextView.text = linkText

        // When
        let noLinkResult = noLinkTextView.detectLinks()
        let linkResult = linkTextView.detectLinks()

        // Then
        XCTAssertTrue(noLinkResult?.isEmpty ?? false)
        XCTAssertFalse(linkResult?.isEmpty ?? false)
    }
    
}

