//
//  NetworkTest.swift
//  SocialAppTests
//
//  Created by William Huang on 24/10/22.
//

import XCTest
@testable import SocialApp

class NetworkTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNetworkErrorDesc() {
        // Given
        let anyError: Error = NetworkError.parametersNil
        let parametersNilErr = NetworkError.parametersNil
        let parameterEncodingFailedErr = NetworkError.parameterEncodingFailed
        let malformedURLErr = NetworkError.malformedURL
        let authenticationErr = NetworkError.authenticationError
        let badRequestErr = NetworkError.badRequest
        let failedErr = NetworkError.failed
        let noResponseDataErr = NetworkError.noResponseData
        let unableToDecodeResponseDataErr = NetworkError.unableToDecodeResponseData
        let otherErr = NetworkError.other(message: "Internal Server Error")
        let otherErrNil = NetworkError.other(message: nil)

        // Then
        XCTAssertEqual(parametersNilErr.localizedDescription, "Empty parameteres")
        XCTAssertEqual(parameterEncodingFailedErr.localizedDescription, "Failed to encode request parameters")
        XCTAssertEqual(malformedURLErr.localizedDescription, "Malformed URL")
        XCTAssertEqual(authenticationErr.localizedDescription, "Authenticatioon failed")
        XCTAssertEqual(badRequestErr.localizedDescription, "Bad request")
        XCTAssertEqual(failedErr.localizedDescription, "API request failed")
        XCTAssertEqual(noResponseDataErr.localizedDescription, "Empty response data")
        XCTAssertEqual(unableToDecodeResponseDataErr.localizedDescription, "Unable to decode response object")
        XCTAssertEqual(otherErr.localizedDescription, "Internal Server Error")
        XCTAssertEqual(otherErrNil.localizedDescription, "")

        XCTAssertEqual(parametersNilErr.getFormattedError(message: "Missing ID"), "Error: Missing ID")
        XCTAssertEqual(anyError.mapToNetworkErrorMsg, "Empty parameteres")
    }

    func testPagingRequest() {
        // Given
        var pagingReq = PagingRequest()

        // Then
        XCTAssertEqual(pagingReq.page, 0)
        XCTAssertEqual(pagingReq.pageSize, 20)

        XCTAssertTrue(pagingReq.isFirstPage())

        pagingReq.loadNextPage()
        XCTAssertEqual(pagingReq.page, 1)

        pagingReq.resetPage()
        XCTAssertEqual(pagingReq.page, 0)

        for _ in 1...22 {
            pagingReq.loadNextPage()
        }

        XCTAssertEqual(pagingReq.page, 20)
        XCTAssertTrue(pagingReq.isMaxPage())
    }

}

