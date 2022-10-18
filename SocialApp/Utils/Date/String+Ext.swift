//
//  String+Ext.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

extension String {
    func convertDate(fromFormat: Date.Format = .utc,
                     toFormat: Date.Format,
                     locale: String = "en_US_POSIX") -> String? {
        var timeStamp = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = fromFormat.rawValue

        if let dateFormat = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = toFormat.rawValue
            timeStamp = dateFormatter.string(from: dateFormat)
        }
        return timeStamp
    }

}
