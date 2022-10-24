//
//  HomePostDetailTest.swift
//  SocialAppTests
//
//  Created by William Huang on 24/10/22.
//

import XCTest
@testable import SocialApp
import RxSwift

class HomePostDetailTest: XCTestCase {


    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadSelectedPost() {
        // Given
        let postDetail = PostDetail.init(id: "post-1",
                                         name: "user-2",
                                         date: "2022-07-18T17:36:58.516Z",
                                         textContent: "test content",
                                         mediaContentPath: "mediaContent",
                                         profilePic: "1",
                                         tagIds: ["user-1", "user-3"])
        let users = User.mocks

        // When
        let sut = HomePostDetailVM(postDetail: postDetail, users: users)

        // Then
        XCTAssertEqual(sut.postDetail.value, postDetail)
        XCTAssertEqual(sut.usersName.value, ["test1 1", "test3 3"])
    }

    func testLoadSelectedPostNoTags() {
        // Given
        let postDetail = PostDetail.init(id: "post-1",
                                         name: "user-2",
                                         date: "2022-07-18T17:36:58.516Z",
                                         textContent: "test content",
                                         mediaContentPath: "mediaContent",
                                         profilePic: "1",
                                         tagIds: [""])
        let users = User.mocks

        // When
        let sut = HomePostDetailVM(postDetail: postDetail, users: users)

        // Then
        XCTAssertEqual(sut.postDetail.value, postDetail)
        XCTAssertEqual(sut.usersName.value, [])
    }
}

