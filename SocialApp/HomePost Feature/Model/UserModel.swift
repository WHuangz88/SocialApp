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
}
