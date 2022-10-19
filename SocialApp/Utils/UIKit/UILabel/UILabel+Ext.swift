//
//  UILabel+Ext.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import UIKit

extension UITextView {

    func detectLinks() -> [NSTextCheckingResult]? {
        if let text = self.text,
           let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue
        ) {
            let matches = detector.matches(
                in: text,
                options: [],
                range: NSRange(
                    location: 0,
                    length: text.utf16.count
                )
            )

            return matches
        }
        return nil
    }

}
