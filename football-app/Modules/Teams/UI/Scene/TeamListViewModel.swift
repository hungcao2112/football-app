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
    
    private let service: TeamServiceProtocol
    
    @Published private(set) var teams: [Team] = []
    @Published private(set) var state: ListViewModelState = .loading
    
    private var cancellables = Set<AnyCancellable>()
    
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

// MARK: - Fetch data

extension TeamListViewModel {
    func fetchData() {
        service.fetchTeams()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .finishedLoading
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] teams in
                guard let self = self else { return }
                self.teams = teams
            }
            .store(in: &cancellables)
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
