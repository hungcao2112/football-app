//
//  TeamListViewModel.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation
import Combine

class TeamListViewModel {
    enum TeamSection {
        case teams
    }
    
    private var service: TeamServiceProtocol
    
    @Published private(set) var teams: [Team] = []
    
    var teamSelectedSubject = PassthroughSubject<[Team], Never>()
    
    var title: String = ""
    
    init(
        teams: [Team],
        service: TeamServiceProtocol = TeamService()
    ) {
        self.teams = teams
        self.title = "Select teams"
        self.service = service
    }
}

// MARK: - ViewModels

extension TeamListViewModel {
    func getTeamListCellViewModel(_ team: Team) -> TeamListCellViewModel {
        TeamListCellViewModel(team: team)
    }
}

// MARK: - Handlers

extension TeamListViewModel {
    func handleSelectTeam(at index: Int) {
        teams[index].isSelected = !teams[index].isSelected
    }
    
    func handleSubmitTeamSelected() {
        teamSelectedSubject.send(teams)
    }
}
