//
//  UICollectionView+Ext.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import UIKit

extension UICollectionView {
    func registerCells(_ cellClasses: UICollectionViewCell.Type...) {
        for type in cellClasses {
            register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
