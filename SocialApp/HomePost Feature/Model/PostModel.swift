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

    static let mocks: [Self] = [
        .init(id: "post-1", position: 1, ownerID: "user-2",
              createdDate: "2022-07-18T17:36:58.516Z",
              textContent: "test content",
              mediaContentPath: "mediaContent",
              tagIDS: ["user-1", "user-3"]),
        .init(id: "post-2", position: 1, ownerID: "user-1",
              createdDate: "2022-07-18T17:36:58.516Z",
              textContent: "test content",
              mediaContentPath: "mediaContent",
              tagIDS: ["user-2", "user-3"])
    ]
}


struct PostDetail: Equatable {
    let id: String
    let name: String
    let date: String
    let textContent: String
    let mediaContentPath: String
    let profilePic: String
    let tagIds: [String]
}
