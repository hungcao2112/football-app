//
//  MatchEntity.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation
import CoreData

extension MatchListEntity {
    func toMatchList() -> MatchList {
        let previous = self.previous?.allObjects as? [MatchEntity] ?? []
        let upcoming = self.upcoming?.allObjects as? [MatchEntity] ?? []
        return MatchList(
            previous: previous.map { $0.match },
            upcoming: upcoming.map { $0.match }
        )
    }
}

extension MatchEntity {
    var match: Match {
        get {
            var match = Match(
                date: self.date,
                description: self.matchDescription ?? "",
                home: self.home ?? "",
                away: self.away ?? "",
                winner: self.winner,
                highlights: self.highlights
            )
            match.homeTeam = homeTeam?.team
            match.awayTeam = awayTeam?.team
            return match
        } set {
            self.date = newValue.date
            self.matchDescription = newValue.description
            self.home = newValue.home
            self.away = newValue.away
            self.winner = newValue.winner
            self.highlights = newValue.highlights
            
            let coreDataStore: CoreDataStoring = CoreDataStore.default
            let homeTeamEntity: TeamEntity = coreDataStore.createEntity()
            let awayTeamEntity: TeamEntity = coreDataStore.createEntity()
            
            if let homeTeam = newValue.homeTeam {
                homeTeamEntity.team = homeTeam
                self.homeTeam = homeTeamEntity
            }
            if let awayTeam = newValue.awayTeam {
                awayTeamEntity.team = awayTeam
                self.awayTeam = awayTeamEntity
            }
        }
    }
}
