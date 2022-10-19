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
        if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else if let firstName = firstName, let lastName = lastName {
            return firstName + " " + lastName
        }
        return "unknown"
    }

    static let mocks: [Self] = [
        .init(id: "user-1", profileImagePath: "1", firstName: "test", lastName: "1"),
        .init(id: "user-2", profileImagePath: "2", firstName: "test", lastName: "2"),
        .init(id: "user-3", profileImagePath: "3", firstName: "test", lastName: "3")
    ]
}
