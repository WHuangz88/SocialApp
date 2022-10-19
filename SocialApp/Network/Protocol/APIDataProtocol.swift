//
//  APIDataProtocol.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

typealias Parameter = [String: Any]

protocol APIData {
    var base: String { get}
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams? { get }
    var headers: [String: String]? { get }
    var absolutePath: String { get }
}

extension APIData {

    var headers: [String: String]? {
        let headers = [
            HTTPHeaderKeys.contentType.rawValue: HeaderContentType.json.rawValue,
        ]
        return headers
    }
    var absolutePath: String {
        base + path
    }
}
