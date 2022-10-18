//
//  HomePostAPI.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

enum HomePostAPI: APIData {

    case fetchPosts(page: Int = 0)
    case fetchUsers

    var base: String {
        return "3fc7b134-bc49-4118-a5bc-82472c90a981.mock.pstmn.io"
    }

    var path: String {
        switch self {
        case .fetchPosts(let page):
            return "/posts/page\(page)"
        case .fetchUsers:
            return "/users"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: RequestParams? {
        return nil
    }

}
