//
//  MatchTeamViewModel.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation

class MatchTeamViewModel {
    private var team: Team
    
    var teamName: String = ""
    var teamImageUrl: URL? = nil
    
    init(team: Team) {
        self.team = team
        self.configureData()
    }
}

// MARK: - Configure data

extension MatchTeamViewModel {
    func configureData() {
        teamName = team.name
        teamImageUrl = team.logo
    }
}
