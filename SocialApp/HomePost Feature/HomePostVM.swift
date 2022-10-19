//
//  HomePostVM.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation
import RxRelay
import RxSwift

protocol HomePostVMProtocol {
    var postCellVMs: BehaviorRelay<[PostDetail]> { get }
    var viewState: BehaviorRelay<UIViewState> { get }
    var users: Users { get }

    func initialLoad()
    func reload()
    func filter(_ search: String)
    func fetchPosts()
    func canLoadMore(index: Int)
}

class HomePostVM: HomePostVMProtocol {

    // Views Binding
    var originalPosts = [PostDetail]()
    let postCellVMs: BehaviorRelay<[PostDetail]> = .init(value: [])
    let viewState: BehaviorRelay<UIViewState> = .init(value: .none)
    var users: Users = []

    var isSearching: Bool = false
    var pageRequest: PagingRequest = .init()
    var disposeBag = DisposeBag()

    private let repo: HomeRepoProtocol
    init(repo: HomeRepoProtocol = HomeRepo()){
        self.repo = repo
    }

    func reload() {
        self.pageRequest.resetPage()
        self.isSearching = false
        self.initialLoad()
    }

    func initialLoad() {
        Single.zip(
            self.repo.fetchUsers(),
            self.repo.fetchPosts(page: pageRequest.page)
        ) { [weak self] (users, posts) -> [PostDetail]? in
            self?.users = users
            return self?.generatePostDetail(posts: posts)
        }
        .observe(on: MainScheduler.instance)
        .subscribe { [weak self] vms in
            guard let self = self, let vms = vms else { return }
            self.postCellVMs.accept(vms)
            self.originalPosts = vms

            self.viewState.accept(.finish)
        } onFailure: { [weak self] error in
            self?.viewState.accept(.errorMessage(error.mapToNetworkErrorMsg))
        }.disposed(by: self.disposeBag)
    }

    func fetchPosts() {
        self.repo.fetchPosts(page: pageRequest.page)
        .observe(on: MainScheduler.instance)
        .subscribe { [weak self] posts in
            guard let self = self else { return }
            let postItems = self.generatePostDetail(posts: posts)

            if self.pageRequest.isFirstPage() {
                self.postCellVMs.accept(postItems)
            } else {
                var curr = self.postCellVMs.value
                curr.append(contentsOf: postItems)
                self.postCellVMs.accept(curr)
            }
            self.originalPosts = self.postCellVMs.value
        } onFailure: { [weak self] error in
            self?.viewState.accept(.errorMessage(error.mapToNetworkErrorMsg))
        }.disposed(by: self.disposeBag)
    }

    func canLoadMore(index: Int) {
        guard index == postCellVMs.value.count - 1
                && !pageRequest.isMaxPage()
                && !isSearching
        else {
            return
        }
        self.pageRequest.loadNextPage()
        self.fetchPosts()
    }

    func filter(_ search: String) {
        if !search.isEmpty && search.split(separator: " ").count < 2 {
            self.isSearching = true
            let filteredByOwner = self.originalPosts.filter {
                let names: [String] = $0.name.split(separator: " ").map { String($0.lowercased()) }
                return names.contains(search.lowercased())
            }

            if !filteredByOwner.isEmpty {
                self.postCellVMs.accept(filteredByOwner)
            } else {
                let filteredByContent = self.originalPosts.filter {
                    return $0.textContent.lowercased().contains(search.lowercased())
                }
                if !filteredByContent.isEmpty {
                    self.postCellVMs.accept(filteredByContent)
                }
            }
        } else if isSearching {
            self.isSearching = false
            self.postCellVMs.accept(originalPosts)
        }
    }

    /// Object Mapper
    private func generatePostDetail(posts: Posts) -> [PostDetail] {
        return posts.reduce(into: [PostDetail]()) { [weak self] (result, post) in
            let user = self?.users.first { $0.id == post.ownerID }
            let vm = PostDetail.init(id: post.id,
                                     name: user?.fullName ?? "",
                                     date: post.createdDate ?? "",
                                     textContent: post.textContent ?? "",
                                     mediaContentPath: post.mediaContentPath ?? "",
                                     profilePic: user?.profileImagePath ?? "",
                                     tagIds: post.tagIDS ?? [])
            result.append(vm)
        }
    }
}
