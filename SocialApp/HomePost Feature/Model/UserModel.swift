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
}
