//
//  MatchListHeaderViewModel.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation

class MatchListHeaderViewModel {
    private var date: Date
    
    var dateString: String = ""
    
    init(date: Date) {
        self.date = date
        self.configureData()
    }
}

// MARK: - Configure data

extension MatchListHeaderViewModel {
    func configureData() {
        dateString = date.toDateString()
    }
}
