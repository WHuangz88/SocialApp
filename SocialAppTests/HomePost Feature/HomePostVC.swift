//
//  HomePostVC.swift
//  SocialAppTests
//
//  Created by William Huang on 24/10/22.
//

import SnapshotTesting
import XCTest
@testable import SocialApp

class HomeFeatureSnap: XCTestCase {

    var viewModel: HomePostVM!
    var stub: HomePostRepoStub!

    override func setUp() {
        super.setUp()
        stub = HomePostRepoStub()
        viewModel = HomePostVM(repo: stub)
    }

    override func tearDown() {
        stub = nil
        viewModel = nil
        super.tearDown()
    }

    func testHomePostVC() {
        let vc = HomePostVC()
        assertSnapshot(matching: vc, as: .image)
    }

    func testHomePostVCWithData() {
        stub.result = .success
        let vc = HomePostVC(viewModel: viewModel)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHomePostDetailVC() {
        // Given
        let postDetail = PostDetail.init(id: "post-1",
                                         name: "user-2",
                                         date: "2022-07-18T17:36:58.516Z",
                                         textContent: "test content",
                                         mediaContentPath: "mediaContent",
                                         profilePic: "1",
                                         tagIds: ["user-1", "user-3"])
        let users = User.mocks

        let vm = HomePostDetailVM(postDetail: postDetail, users: users)
        let vc = HomePostDetailVC(viewModel: vm)
        assertSnapshot(matching: vc, as: .image)
    }
}

