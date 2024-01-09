//
//  TeamDetailViewModel.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation
import Combine
import CoreData

class TeamDetailViewModel {
    enum Section {
        case matches
    }
    
    private var team: Team
    
    @Published private(set) var matches: [Match] = []
    @Published private(set) var state: ListViewModelState = .loading
    
    private var cancellables = Set<AnyCancellable>()
    
    let title: String
    let coreDataStore: CoreDataStoring = CoreDataStore.default
    
    init(team: Team) {
        self.team = team
        self.title = "Team Detail"
        self.configureData()
    }
}

// MARK: - Fetch data

extension TeamDetailViewModel {
    func fetchData() {
        let matchRequest = NSFetchRequest<MatchListEntity>(entityName: MatchListEntity.entityName)
        
        coreDataStore.publicher(fetch: matchRequest)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .finishedLoading
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] matchList in
                guard let self = self else { return }
                self.state = .finishedLoading
                let matches = matchList.first?.toMatchList().previous ?? []
                let filteredMatches = matches.filter {
                    $0.home == self.team.name ||
                    $0.away == self.team.name
                }.sorted(by: { ($0.date ?? Date()) > ($1.date ?? Date()) })
                self.matches = filteredMatches
            }
            .store(in: &cancellables)
    }
}

// MARK: - ViewModels

extension TeamDetailViewModel {
    func getTeamDetailHeaderViewModel() -> TeamDetailHeaderViewModel {
        TeamDetailHeaderViewModel(team: team)
    }
    
    func getTeamDetailCellViewModel(match: Match) -> TeamDetailCellViewModel {
        TeamDetailCellViewModel(team: team, match: match)
    }
}

// MARK: - Configure Data

extension TeamDetailViewModel {
    func configureData() {
    }
}
