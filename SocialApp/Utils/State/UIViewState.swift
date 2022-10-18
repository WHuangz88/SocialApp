//
//  UIViewState.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

public enum UIViewState {
    case loading
    case empty
    case errorMessage(String?)
    case finish
    case none
}
