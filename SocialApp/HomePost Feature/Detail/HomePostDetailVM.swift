//
//  HomePostDetailVM.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation
import RxRelay
import RxSwift

class HomePostDetailVM {

    // Views Binding
    let postDetail: BehaviorRelay<PostDetail>
    let usersName: BehaviorRelay<[String]> = .init(value: [])

    init(postDetail: PostDetail, users: Users){
        self.postDetail = .init(value: postDetail)
        let postUsers = postDetail.tagIds.reduce(into: [String](), { result, id in
            if let user = users.first(where: { $0.id == id }) {
                result.append(user.fullName)
            }
        })
        usersName.accept(postUsers)
    }
}


