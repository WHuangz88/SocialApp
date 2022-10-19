//
//  UITableView+Ext.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import UIKit

public protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }

public extension UITableView {
    func registerCells(_ cellClasses: UITableViewCell.Type...) {
        for type in cellClasses {
            register(type, forCellReuseIdentifier: type.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
