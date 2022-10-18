//
//  HomePostVMProtocol.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

protocol HomePostVMProtocol {
    func fetchPosts(page: Int)
    func canLoadMore(index: Int)
}

class HomePostVM: HomePostVMProtocol {

    // Views Binding
    @RxPublished var viewState: UIViewState = .loading
    @RxBehavior var posts: Posts = []

    private let api: NetworkService
    init(api: NetworkService = URLSessionNetworkService()){
        self.api = api
    }

    func fetchPosts(page: Int) {
        self.api.request(request: HomePostAPI.fetchPosts(page: page),
                         type: Posts.self) { result in
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                self.viewState = .errorMessage(error.localizedDescription)
            }
        }
    }

    func canLoadMore(index: Int) {

    }
}
