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
    var dataType: ResponseDataType { get }
    var absolutePath: String { get }
}

extension APIData {
    var absolutePath: String {
        base + path
    }
}
