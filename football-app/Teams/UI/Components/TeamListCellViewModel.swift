//
//  TeamListCellViewModel.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation

class TeamListCellViewModel {
    private var team: Team
    
    var teamImageUrl: URL?
    var teamName: String = ""
    var isSelected: Bool = false
    
    init(team: Team) {
        self.team = team
        self.configureData()
    }
}

// MARK: - Configure data

private extension TeamListCellViewModel {
    func configureData() {
        teamImageUrl = team.logo
        teamName = team.name
        isSelected = team.isSelected
    }
}
