//
//  UIView+Ext.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

public extension UIView {
    /// add Multiple subviews using Variadic
    func addSubviews(_ view: UIView...) {
        view.forEach { self.addSubview($0) }
    }
}

