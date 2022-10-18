//
//  NetworkConfig.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

enum ResponseDataType {
    case Data
    case JSON
}

enum Encoding: String {
    case URL
    case JSON
}

enum HeaderContentType: String {
    case json = "application/json"
}

enum HTTPHeaderKeys: String {
    case contentType = "Content-Type"
}

struct RequestParams {
    let urlParameters: [String: String]?
    let bodyParameters: [String: Any]?
    let contentType: HeaderContentType

    init(urlParameters: [String: String]? = nil,
         bodyParameters: [String: Any]? = nil,
         contentType: HeaderContentType = .json) {
        self.urlParameters = urlParameters
        self.bodyParameters = bodyParameters
        self.contentType = contentType
    }
}

struct PagingRequest {
    var page: Int
    var pageSize: Int

    init(page: Int = 0,
                pageSize: Int = 20) {
        self.page = page
        self.pageSize = pageSize
    }
    func isFirstPage() -> Bool {
        return page == 1
    }

    func isMaxPage() -> Bool {
        self.page == pageSize
    }

    mutating func loadNextPage() {
        self.page += 1
    }

    mutating func resetPage() {
        self.page = 1
    }
}


