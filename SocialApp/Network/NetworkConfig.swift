//
//  NetworkConfig.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

public enum ResponseDataType {
    case Data
    case JSON
}

public enum Encoding: String {
    case URL
    case JSON
}

enum HeaderContentType: String {
    case json = "application/json"
}

enum HTTPHeaderKeys: String {
    case contentType = "Content-Type"
}

public struct RequestParams {
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

