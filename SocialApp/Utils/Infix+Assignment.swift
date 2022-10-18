//
//  Infix+Assignment.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

infix operator ~!~ : AssignmentPrecedence

public func ~!~<T: AnyObject>(left: T, right: (T) -> Void) -> T {
    right(left)
    return left
}
