//
//  String+Ext.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:self)
    }
}
