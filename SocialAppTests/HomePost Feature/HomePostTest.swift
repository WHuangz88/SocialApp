//
//  HomePostTest.swift
//  SocialAppTests
//
//  Created by William Huang on 19/10/22.
//

import XCTest
@testable import SocialApp
import RxSwift

class HomePostTest: XCTestCase {

    var sut: HomePostVM!
    var stub: HomePostRepoStub!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        stub = HomePostRepoStub()
        sut = HomePostVM(repo: stub)
    }

    override func tearDown() {
        disposeBag = nil
        stub = nil
        sut = nil
        super.tearDown()
    }

    func testInitialLoadSuccess() {
        // Given
        stub.result = .success

        // When
        sut.initialLoad()

        // Then
        XCTAssertTrue(sut.pageRequest.isFirstPage())
        XCTAssertFalse(sut.users.isEmpty)
        XCTAssertFalse(sut.originalPosts.isEmpty)
        XCTAssertFalse(sut.postCellVMs.value.isEmpty)
    }

    func testInitialLoadFailure() {
        // Given
        stub.result = .failure

        // When
        sut.initialLoad()

        // Then
        XCTAssertTrue(sut.pageRequest.isFirstPage())
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertTrue(sut.originalPosts.isEmpty)
        XCTAssertTrue(sut.postCellVMs.value.isEmpty)
        XCTAssertEqual(sut.viewState.value, .errorMessage(NetworkError.noResponseData.localizedDescription))
    }

    func testFetchFirstPostSuccess() {
        // Given
        stub.result = .success
        sut.pageRequest.resetPage()

        // When
        sut.fetchPosts()

        // Then
        XCTAssertTrue(sut.pageRequest.isFirstPage())
        XCTAssertFalse(sut.originalPosts.isEmpty)
        XCTAssertFalse(sut.postCellVMs.value.isEmpty)
    }

    func testFetchFirstPostError() {
        // Given
        stub.result = .failure
        sut.pageRequest.resetPage()

        // When
        sut.fetchPosts()

        // Then
        XCTAssertTrue(sut.pageRequest.isFirstPage())
        XCTAssertTrue(sut.originalPosts.isEmpty)
        XCTAssertEqual(sut.viewState.value, .errorMessage(NetworkError.noResponseData.localizedDescription))
    }

    func testCanLoadMoreSuccess() {
        // Given
        testFetchFirstPostSuccess() // set initial load
        stub.result = .success
        sut.pageRequest.resetPage() // reset page to 0

        // When
        /// load data when it reach to last item in index
        /// initial page limit in initial load is 2
        /// load more should be triggered at index 1
        sut.canLoadMore(index: 1)

        // Then
        XCTAssertFalse(sut.pageRequest.isMaxPage())
        XCTAssertEqual(sut.pageRequest.page, 1)
        XCTAssertEqual(sut.postCellVMs.value.count, 4)
    }

    func testCanLoadMoreFail() {
        // Given
        testFetchFirstPostSuccess() // set initial load
        stub.result = .success
        sut.pageRequest = .init(page: 0, pageSize: 0) // reach the maxPage

        sut.canLoadMore(index: 1)

        // Then
        XCTAssertEqual(sut.pageRequest.isMaxPage(), true)
        XCTAssertEqual(sut.pageRequest.page, 0)
        XCTAssertEqual(sut.postCellVMs.value.count, 2)
    }

    func testShouldNotLoadMoreWhenSearching() {
        // Given
        testFetchFirstPostSuccess() // set initial load
        stub.result = .success
        sut.isSearching = true
        sut.pageRequest.resetPage() // reset page to 0

        // When
        /// load data when it reach to last item in index
        /// initial page limit in initial load is 2
        /// load more should be triggered at index 1
        sut.canLoadMore(index: 1)

        // Then
        XCTAssertFalse(sut.pageRequest.isMaxPage())
        XCTAssertTrue(sut.isSearching)
        XCTAssertEqual(sut.pageRequest.page, 0)
    }

    func testShouldReloadSuccess() {
        // Given
        stub.result = .success

        // When
        sut.reload()

        // Then
        XCTAssertTrue(sut.pageRequest.isFirstPage())
        XCTAssertFalse(sut.isSearching)
        XCTAssertFalse(sut.users.isEmpty)
        XCTAssertFalse(sut.originalPosts.isEmpty)
        XCTAssertFalse(sut.postCellVMs.value.isEmpty)
    }

    func testFilterSearchByOwner() {
        // Given
        testInitialLoadSuccess()

        // When
        sut.filter("test1")

        // Then
        XCTAssertTrue(sut.isSearching)
        XCTAssertEqual(sut.postCellVMs.value.count, 1) // since in mock there are only 1 test1 user
    }

    func testFilterSearchByTextContent() {
        // Given
        testFetchFirstPostSuccess()

        // When
        sut.filter("content")

        // Then
        XCTAssertTrue(sut.isSearching)
        XCTAssertEqual(sut.postCellVMs.value.count, 2) // since in mock there are only 2 data
    }

    func testShouldNotFilterByWords() {
        // Given
        testFetchFirstPostSuccess()

        // When
        sut.filter("Test1 1")

        // Then
        XCTAssertFalse(sut.isSearching)
        XCTAssertEqual(sut.postCellVMs.value.count, 2)
    }

    func testShouldResetFilterOnSearching() {
        // Given
        testFetchFirstPostSuccess()
        sut.isSearching = true

        // When
        sut.filter("")

        // Then
        XCTAssertFalse(sut.isSearching)
        XCTAssertEqual(sut.postCellVMs.value, sut.originalPosts)
    }

}
