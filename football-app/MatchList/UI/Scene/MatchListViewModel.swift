//
//  MatchListViewModel.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation
import Combine

enum ListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

class MatchListViewModel: MatchListViewModelProtocol {
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
                var matches = self.matchPhase == .previous ? matchList.previous : matchList.upcoming
                
                for (index, match) in matches.enumerated() {
                    matches[index].homeTeam = teams.first(where: { $0.name == match.home.trimmingCharacters(in: .whitespaces) })
                    matches[index].awayTeam = teams.first(where: { $0.name == match.away.trimmingCharacters(in: .whitespaces) })
                }
                
                self.groupedMatches = self.groupMatches(matches)
                self.teams = teams
                self.matches = matches
            }
            .store(in: &cancellables)
        
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
