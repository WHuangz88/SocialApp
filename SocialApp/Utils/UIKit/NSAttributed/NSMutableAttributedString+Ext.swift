//
//  NSMutableAttributedString+Ext.swift
//  SocialApp
//
//  Created by William Huang on 19/10/22.
//

import UIKit

extension NSMutableAttributedString {
    static func attributeForFont(fullText: String,
                                 normalFont: UIFont,
                                 normalColor: UIColor? = .black,
                                 textChecking: [NSTextCheckingResult]
    ) -> NSMutableAttributedString {
        let normalAtt: [NSAttributedString.Key: Any] = [
            NSMutableAttributedString.Key.font: normalFont,
            NSMutableAttributedString.Key.foregroundColor: normalColor as Any
        ]

        let finalAtt = NSMutableAttributedString.init(string: fullText, attributes: normalAtt)
        for textCheck in textChecking {
            if let url = textCheck.url?.absoluteString {
                finalAtt.addAttribute(.link, value: url, range: textCheck.range)
            }
        }

        return finalAtt
    }
}

