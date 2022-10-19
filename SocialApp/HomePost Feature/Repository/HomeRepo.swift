//
//  HomeRepo.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import RxSwift

protocol HomeRepoProtocol {
    func fetchUsers() -> Single<Users>
    func fetchPosts(page: Int) -> Single<Posts>
}

struct HomeRepo: HomeRepoProtocol {

    private let api: NetworkService
    init(api: NetworkService = URLSessionNetworkService()) {
        self.api = api
    }

    func fetchUsers() -> Single<Users> {
        return self.api.request(request: HomePostAPI.fetchUsers,
                        type: Users.self)
    }

    func fetchPosts(page: Int) -> Single<Posts> {
        return self.api.request(request: HomePostAPI.fetchPosts(page: page),
                         type: Posts.self)
    }
}
