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
    var viewState: PublishSubject<UIViewState> { get }
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
    var postCellVMs: BehaviorRelay<[PostDetail]> = .init(value: [])
    var viewState: PublishSubject<UIViewState> = .init()
    var users: Users = []

    private var isSearching: Bool = false
    private var pageRequest: PagingRequest = .init()
    private var disposeBag = DisposeBag()

    private let api: NetworkService
    init(api: NetworkService = URLSessionNetworkService()){
        self.api = api
    }

    func reload() {
        self.pageRequest.resetPage()
        self.postCellVMs = .init(value: [])
        self.initialLoad()
    }

    func initialLoad() {
        Single.zip(
            self.api.request(request: HomePostAPI.fetchUsers,
                             type: Users.self),
            self.api.request(request: HomePostAPI.fetchPosts(page: pageRequest.page),
                             type: Posts.self)
        ) { [weak self] (users, posts) -> [PostDetail]? in
            self?.users = users
            return self?.generatePostCellVM(posts: posts)
        }
        .runInThread()
        .subscribe { [weak self] vms in
            guard let self = self, let vms = vms else { return }
            self.postCellVMs.accept(vms)
            self.originalPosts = vms

            self.viewState.onNext(.finish)
        } onFailure: { [weak self] error in
            self?.viewState.onNext(.errorMessage(error.localizedDescription))
        }.disposed(by: self.disposeBag)
    }

    func fetchPosts() {
        self.api.request(request: HomePostAPI.fetchPosts(page: pageRequest.page),
                         type: Posts.self)
        .runInThread()
        .subscribe { [weak self] posts in
            guard let self = self else { return }
            let postItems = self.generatePostCellVM(posts: posts)

            if self.pageRequest.isFirstPage() {
                self.postCellVMs.accept(postItems)
            } else {
                var curr = self.postCellVMs.value
                curr.append(contentsOf: postItems)
                self.postCellVMs.accept(curr)
            }
            self.originalPosts = self.postCellVMs.value
        } onFailure: { [weak self] error in
            self?.viewState.onNext(.errorMessage(error.localizedDescription))
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
    private func generatePostCellVM(posts: Posts) -> [PostDetail] {
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
