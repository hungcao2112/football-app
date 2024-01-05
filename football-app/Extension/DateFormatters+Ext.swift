//
//  DateFormatters.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
}
