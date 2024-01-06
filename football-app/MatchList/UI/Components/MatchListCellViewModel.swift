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
    
    public var buttonTappedSubject = PassthroughSubject<URL?, Never>()
    
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
    }
}

// MARK: - ViewModels

extension MatchListCellViewModel {
    func getHomeTeamViewModel() -> MatchTeamViewModel? {
        if let homeTeam = match.homeTeam {
            return MatchTeamViewModel(team: homeTeam)
        }
        return nil
    }
    
    func getAwayTeamViewModel() -> MatchTeamViewModel? {
        if let awayTeam = match.awayTeam {
            return MatchTeamViewModel(team: awayTeam)
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
