//
//  HomeRepoStub.swift
//  SocialAppTests
//
//  Created by William Huang on 19/10/22.
//

@testable import SocialApp
import RxSwift

struct HomeRepoStub: HomeRepoProtocol {

    enum PossibleResults {
        case success
        case failure
    }

    var result: PossibleResults = .success

    func fetchUsers() -> Single<Users> {
        if result == .success {
            return .just(User.mocks)
        }
        return .error(NetworkError.noResponseData)
    }

    func fetchPosts(page: Int) -> Single<Posts> {
        if result == .success {
            return .just(Post.mocks)
        }
        return .error(NetworkError.noResponseData)
    }

}
