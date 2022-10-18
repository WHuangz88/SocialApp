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
    var postCellVMs: BehaviorRelay<[PostCellVM]> { get }
    var viewState: PublishSubject<UIViewState> { get }

    func initialLoad()
    func reload()
    func fetchPosts()
    func canLoadMore(index: Int)
}

class HomePostVM: HomePostVMProtocol {

    // Views Binding
    var postCellVMs: BehaviorRelay<[PostCellVM]> = .init(value: [])
    var viewState: PublishSubject<UIViewState> = .init()

    private var users: BehaviorRelay<Users> = .init(value: [])
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
        ) { [weak self] (users, posts) -> [PostCellVM]? in
            self?.users = .init(value: users)
            return self?.generatePostCellVM(posts: posts)
        }
        .runInThread()
        .subscribe { [weak self] vms in
            guard let self = self, let vms = vms else { return }
            self.postCellVMs.accept(vms)
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
        } onFailure: { [weak self] error in
            self?.viewState.onNext(.errorMessage(error.localizedDescription))
        }.disposed(by: self.disposeBag)
    }

    func canLoadMore(index: Int) {
        guard index == postCellVMs.value.count - 1 && !pageRequest.isMaxPage() else {
            return
        }
        self.pageRequest.loadNextPage()
        self.fetchPosts()
    }

    /// Object Mapper
    private func generatePostCellVM(posts: Posts) -> [PostCellVM] {
        return posts.reduce(into: [PostCellVM]()) { [weak self] (result, post) in
            let user = self?.users.value.first { $0.id == post.ownerID }
            let vm = PostCellVM.init(name: user?.fullName ?? "",
                                     date: post.createdDate ?? "",
                                     content: post.textContent ?? "",
                                     profilePic: user?.profileImagePath ?? "")
            result.append(vm)
        }
    }
}
