//
//  Date+Ext.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
    
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
}
