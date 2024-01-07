//
//  TeamEntity.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation
import CoreData

extension TeamListEntity {
    func toTeams() -> [Team] {
        let teamEntities = self.teams?.allObjects as? [TeamEntity] ?? []
        return teamEntities.map { $0.team }
    }
}

extension TeamEntity {
    var team: Team {
        get {
            return Team(
                id: self.id ?? "",
                name: self.name ?? "",
                logo: self.logo
            )
        } set {
            self.id = newValue.id
            self.name = newValue.name
            self.logo = newValue.logo
        }
    }
}
