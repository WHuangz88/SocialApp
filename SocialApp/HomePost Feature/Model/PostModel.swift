//
//  PostModel.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

typealias Posts = [Post]

struct Post: Decodable {
    let id: String
    let position: Int?
    let ownerID, createdDate, textContent: String?
    let mediaContentPath: String?
    let tagIDS: [String]?

    enum CodingKeys: String, CodingKey {
        case id, position
        case ownerID = "ownerId"
        case createdDate, textContent, mediaContentPath
        case tagIDS = "tagIds"
    }
}
