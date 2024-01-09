//
//  MatchListCellViewModel.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation
import Combine

class MatchListCellViewModel {
    private var match: Match
    
    var descriptionText: String = ""
    var homeTeamName: String = ""
    var awayTeamName: String = ""
    var timeText: String = ""
    var showHighlight: Bool = false
    var isHomeTeamWinner: Bool? = nil
    
    var buttonTappedSubject = PassthroughSubject<URL?, Never>()
    var teamTappedSubject = PassthroughSubject<Team, Never>()
    
    init(match: Match) {
        self.match = match
        self.configureData()
    }
}

// MARK: - Configure data

private extension MatchListCellViewModel {
    func configureData() {
        descriptionText = match.description
        homeTeamName = match.home
        awayTeamName = match.away
        timeText = match.date?.toTimeString() ?? ""
        showHighlight = match.highlights != nil
        if let winner = match.winner {
            isHomeTeamWinner = winner.trimmingCharacters(in: .whitespaces) == match.home.trimmingCharacters(in: .whitespaces)
        }
    }
}

// MARK: - ViewModels

extension MatchListCellViewModel {
    func getHomeTeamViewModel() -> MatchTeamViewModel? {
        if let homeTeam = match.homeTeam {
            let viewModel = MatchTeamViewModel(team: homeTeam)
            viewModel.viewTappedSubject = teamTappedSubject
            return viewModel
        }
        return nil
    }
    
    func getAwayTeamViewModel() -> MatchTeamViewModel? {
        if let awayTeam = match.awayTeam {
            let viewModel = MatchTeamViewModel(team: awayTeam)
            viewModel.viewTappedSubject = teamTappedSubject
            return viewModel
        }
        return nil
    }
}

// MARK: - Handlers

extension MatchListCellViewModel {
    func handleButtonTapped() {
        buttonTappedSubject.send(match.highlights)
    }
}
