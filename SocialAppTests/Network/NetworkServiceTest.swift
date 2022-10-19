//
//  NetworkServiceTest.swift
//  SocialAppTests
//
//  Created by William Huang on 19/10/22.
//

import XCTest
@testable import SocialApp
import RxSwift

class NetworkServiceTest: XCTestCase {

    var sut: URLSessionNetworkService!
    var spy: NetworkManagerProtocol!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        spy = NetworkManagerSpy()
        sut = URLSessionNetworkService(authorizationManager: spy)
    }

    override func tearDown() {
        disposeBag = nil
        spy = nil
        sut = nil
        super.tearDown()
    }

    func testRequestAPIDataSuccess() {
        // Given
        let expectation = expectation(description: "Result not Empty")

        // When
        sut.request(request: DummyAPI.success, type: Posts.self)
            .subscribe(onSuccess: { result in
                XCTAssertEqual(
                    result.isEmpty, false
                )
                expectation.fulfill()
            }).disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 0.1)
    }

    func testRequestAPIDataFail() {
        // Given
        let expectation = expectation(description: "Result not Empty")

        // When
        sut.request(request: DummyAPI.fail, type: Posts.self)
            .subscribe(onFailure: { err in
                XCTAssertNotNil(err)
                expectation.fulfill()
            }).disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 0.1)
    }

}

enum DummyAPI: APIData {

    case success
    case fail

    var base: String {
        switch self {
        case .success:
            return "dummy"
        default:
            return ""
        }
    }

    var path: String {
        switch self {
        case .success:
            return "/dummy"
        default:
            return ""
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: RequestParams? {
        return nil
    }

}


