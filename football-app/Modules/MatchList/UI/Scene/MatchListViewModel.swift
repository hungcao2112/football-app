//
//  MatchListViewModel.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation
import Combine
import CoreData

enum ListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

public class MatchListViewModel: MatchListViewModelProtocol {
    private let matchPhase: MatchPhase
    private let matchService: MatchServiceProtocol
    private let teamService: TeamServiceProtocol
    
    private var teams: [Team] = []
    private var matches: [Match] = []
    private var selectedTeam: Team?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var groupedMatches: [GroupedMatch] = []
    @Published private(set) var matchHighlights: URL? = nil
    @Published private(set) var state: ListViewModelState = .loading
    
    var teamTappedSubject = PassthroughSubject<Void, Never>()
    var matchHighlightsTappedSubject = PassthroughSubject<URL?, Never>()
    var title: String = ""
    
    let coreDataStore: CoreDataStoring = CoreDataStore.default
    
    init(
        matchPhase: MatchPhase,
        matchService: MatchServiceProtocol = MatchService(),
        teamService: TeamServiceProtocol = TeamService()
    ) {
        self.matchPhase = matchPhase
        self.title = matchPhase.title
        self.matchService = matchService
        self.teamService = teamService
    }
}

// MARK: - Fetch data

extension MatchListViewModel {
    func fetchData() {
        state = .loading
        fetchDataFromServer(enableHandling: false)
        fetchDataLocally()
    }
    
    func fetchDataLocally() {
        let matchRequest = NSFetchRequest<MatchListEntity>(entityName: MatchListEntity.entityName)
        let teamListRequest = NSFetchRequest<TeamListEntity>(entityName: TeamListEntity.entityName)
        
        let localDataPublishers = Publishers.CombineLatest(
            coreDataStore.publicher(fetch: matchRequest),
            coreDataStore.publicher(fetch: teamListRequest)
        )
        
        localDataPublishers
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .finishedLoading
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] receivedObject in
                guard let self = self else { return }
                let matchListEntity = receivedObject.0
                let teamListEntity = receivedObject.1
                if matchListEntity.isEmpty || teamListEntity.isEmpty {
                    self.fetchDataFromServer(enableHandling: true)
                } else {
                    self.state = .finishedLoading
                }
                
                let matchList = matchListEntity.first?.toMatchList()
                let teams = teamListEntity.first?.toTeams() ?? []
                
                self.handleReceivedData(matchList: matchList, teams: teams)
            }
            .store(in: &cancellables)
    }
    
    func fetchDataFromServer(enableHandling: Bool) {
        let combinedPublisher = Publishers.CombineLatest(
            matchService.fetchMatches(),
            teamService.fetchTeams()
        )
        
        combinedPublisher
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .finishedLoading
                case .failure(let error):
                    self.state = .error(error)
                }
            } receiveValue: { [weak self] receivedObject in
                guard let self = self else { return }
                let matchList = receivedObject.0
                let teams = receivedObject.1
                let configMatchList = self.handleConfigureMatches(
                    matchList: matchList,
                    teams: teams
                )
                self.deleteAllLocalData()
                self.saveMatchList(configMatchList)
                self.saveTeams(teams)
                
                if enableHandling {
                    self.handleReceivedData(matchList: configMatchList, teams: teams)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Local data handlers

private extension MatchListViewModel {
    func saveMatchList(_ matchList: MatchList) {
        let action: Action = { [weak self] in
            guard let self = self else { return }
            let matchListEntity: MatchListEntity = self.coreDataStore.createEntity()
            
            let previous = matchList.previous.map {
                let match: MatchEntity = self.coreDataStore.createEntity()
                match.match = $0
                return match
            }
            
            let upcoming = matchList.upcoming.map {
                let match: MatchEntity = self.coreDataStore.createEntity()
                match.match = $0
                return match
            }
            
            matchListEntity.previous = NSSet(array: previous)
            matchListEntity.upcoming = NSSet(array: upcoming)
        }
        
        coreDataStore
            .publicher(save: action)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("[CORE DATA]: \(error)")
                }
            } receiveValue: { success in
                print("[CORE DATA]: Save match list successfully")
            }
            .store(in: &cancellables)
    }
    
    func saveTeams(_ teams: [Team]) {
        let action: Action = { [weak self] in
            guard let self = self else { return }
            let teamList: TeamListEntity = self.coreDataStore.createEntity()
            
            let teamEntities = teams.map {
                let team: TeamEntity = self.coreDataStore.createEntity()
                team.team = $0
                return team
            }
            teamList.teams = NSSet(array: teamEntities)
        }
        
        coreDataStore
            .publicher(save: action)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("[CORE DATA]: \(error)")
                }
            } receiveValue: { success in
                print("[CORE DATA]: Save team list successfully")
            }
            .store(in: &cancellables)
    }
    
    func deleteAllLocalData() {
        let matchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MatchListEntity.entityName)
        let teamListRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TeamListEntity.entityName)
        
        let localDataPublishers = Publishers.CombineLatest(
            coreDataStore.publicher(delete: matchRequest),
            coreDataStore.publicher(delete: teamListRequest)
        )
        
        localDataPublishers
            .sink { completion in
                if case .failure(let error) = completion {
                    print("[CORE DATA]: \(error)")
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
    }
}

// MARK: - Handlers

private extension MatchListViewModel {
    func handleConfigureMatches(matchList: MatchList?, teams: [Team]) -> MatchList {
        var previous = matchList?.previous ?? []
        for (index, match) in previous.enumerated() {
            previous[index].homeTeam = teams.first(where: { $0.name == match.home.trimmingCharacters(in: .whitespaces) })
            previous[index].awayTeam = teams.first(where: { $0.name == match.away.trimmingCharacters(in: .whitespaces) })
        }
        
        var upcoming = matchList?.upcoming ?? []
        for (index, match) in upcoming.enumerated() {
            upcoming[index].homeTeam = teams.first(where: { $0.name == match.home.trimmingCharacters(in: .whitespaces) })
            upcoming[index].awayTeam = teams.first(where: { $0.name == match.away.trimmingCharacters(in: .whitespaces) })
        }
        return MatchList(previous: previous, upcoming: upcoming)
    }
    
    func handleReceivedData(matchList: MatchList?, teams: [Team]) {
        guard let matchList = matchList else { return }
        var matches = self.matchPhase == .previous ? matchList.previous : matchList.upcoming
        
//        for (index, match) in matches.enumerated() {
//            matches[index].homeTeam = teams.first(where: { $0.name == match.home.trimmingCharacters(in: .whitespaces) })
//            matches[index].awayTeam = teams.first(where: { $0.name == match.away.trimmingCharacters(in: .whitespaces) })
//        }
        
        self.groupedMatches = self.groupMatches(matches)
        self.teams = teams
        self.matches = matches
    }
}

// MARK: - Methods

extension MatchListViewModel {
    func groupMatches(_ matches: [Match]) -> [GroupedMatch] {
        let groupedMatches = Dictionary(grouping: matches, by: { $0.date })
        let groupedMatchArray = groupedMatches.map { (date, matches) in
            return GroupedMatch(date: date, matches: matches)
        }
        let sortedGroupedMatches = self.matchPhase == .previous ?
        groupedMatchArray.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) } :
        groupedMatchArray.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        return sortedGroupedMatches
    }
}

// MARK: - ViewModels

extension MatchListViewModel {
    func getMatchCellViewModel(_ match: Match) -> MatchListCellViewModel {
        let viewModel = MatchListCellViewModel(match: match)
        viewModel.buttonTappedSubject.assign(to: &$matchHighlights)
        viewModel.teamTappedSubject.sink { [weak self] team in
            guard let self = self else { return }
            self.selectedTeam = team
            self.teamTappedSubject.send()
        }
        .store(in: &cancellables)
        return viewModel
    }
    
    func getMatchHeaderViewModel(index: Int) -> MatchListHeaderViewModel {
        let date = self.groupedMatches[index].date ?? Date()
        let viewModel = MatchListHeaderViewModel(date: date)
        return viewModel
    }
    
    func getTeamListViewModel() -> TeamListViewModel {
        let viewModel = TeamListViewModel(teams: self.teams)
        viewModel.teamSelectedSubject.sink { [weak self] teams in
            guard let self = self else { return }
            self.teams = teams
            let selectedTeams = self.teams.filter({ $0.isSelected })
            var filteredMatches = self.matches
            if !selectedTeams.isEmpty {
                filteredMatches = self.matches
                    .filter {
                        selectedTeams.map { $0.name }.contains( $0.home ) ||
                        selectedTeams.map { $0.name }.contains( $0.away )
                    }
            }
            self.groupedMatches = self.groupMatches(filteredMatches)
        }
        .store(in: &cancellables)
        return viewModel
    }
    
    func getTeamDetailViewModel() -> TeamDetailViewModel? {
        guard let team = selectedTeam else { return nil }
        return TeamDetailViewModel(team: team)
    }
}
