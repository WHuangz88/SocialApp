//
//  UserModel.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

typealias Users = [User]

struct User: Codable {
    let id: String
    let profileImagePath, firstName, lastName: String?

    var fullName: String {
        if let firstName = firstName, let lastName = lastName {
            return firstName + " " + lastName
        } else {
            return firstName ?? lastName ?? "unknown"
        }
    }

    static let mocks: [Self] = [
        .init(id: "user-1", profileImagePath: "1", firstName: "test1", lastName: "1"),
        .init(id: "user-2", profileImagePath: "2", firstName: "test2", lastName: "2"),
        .init(id: "user-3", profileImagePath: "3", firstName: "test3", lastName: "3")
    ]
}
