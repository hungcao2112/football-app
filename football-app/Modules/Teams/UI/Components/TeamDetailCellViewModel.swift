//
//  TeamDetailCellViewModel.swift
//  football-app
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation

class TeamDetailCellViewModel {
    private var match: Match
    private var team: Team
    
    var dateText: String = ""
    var teamName: String = ""
    var teamImageUrl: URL?
    var isWinner: Bool = false
    var resultText: String = ""
    
    init(team: Team, match: Match) {
        self.match = match
        self.team = team
        self.configureData()
    }
}

// MARK: - Configure data

private extension TeamDetailCellViewModel {
    func configureData() {
        dateText = match.date?.toDateAndTimeString() ?? ""
        if team.name == match.home {
            teamImageUrl = match.awayTeam?.logo
            teamName = match.away
        } else {
            teamImageUrl = match.homeTeam?.logo
            teamName = match.home
        }
        isWinner = match.winner == team.name
        resultText = isWinner ? "WIN" : "LOSE"
    }
}

