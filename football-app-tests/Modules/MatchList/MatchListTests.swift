//
//  MatchListTests.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation
import Combine
import XCTest
@testable import football_app

class MatchListTests: XCTestCase {
    var viewModel: MatchListViewModel!
    let matchService = MockMatchService()
    let teamService = MockTeamService()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

// MARK: - Methods

extension MatchListTests {
    
    func testFetchPreviousMatchSuccess() {
        // given
        viewModel = MatchListViewModel(
            matchPhase: .previous,
            matchService: matchService,
            teamService: teamService
        )
        let expectation = expectation(description: "Previous matches fetched and decoded successfully")
        
        // When
        viewModel.fetchDataFromServer(enableHandling: true)
        
        // Then
        viewModel.$groupedMatches
            .receive(on: RunLoop.main)
            .dropFirst(1)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { groupedMatches in
                XCTAssertNotEqual(groupedMatches.count, 0, "Matches should not be empty")
                for groupMatch in groupedMatches {
                    let nilHomeTeamMatches = groupMatch.matches.filter { $0.homeTeam == nil }
                    let nilAwayIteamMatches = groupMatch.matches.filter { $0.awayTeam == nil }
                    XCTAssertEqual(nilHomeTeamMatches.count, 0, "Home Team should not be nil")
                    XCTAssertEqual(nilAwayIteamMatches.count, 0, "Away Team Team should not be nil")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 4)
    }
    
    func testFetchUpcomingMatchSuccess() {
        // given
        viewModel = MatchListViewModel(
            matchPhase: .upcoming,
            matchService: matchService,
            teamService: teamService
        )
        let expectation = expectation(description: "Upcoming matches fetched and decoded successfully")
        
        // When
        viewModel.fetchDataFromServer(enableHandling: true)
        
        // Then
        viewModel.$groupedMatches
            .receive(on: RunLoop.main)
            .dropFirst(1)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { groupedMatches in
                XCTAssertNotEqual(groupedMatches.count, 0, "Matches should not be empty")
                for groupMatch in groupedMatches {
                    let nilHomeTeamMatches = groupMatch.matches.filter { $0.homeTeam == nil }
                    let nilAwayIteamMatches = groupMatch.matches.filter { $0.awayTeam == nil }
                    XCTAssertEqual(nilHomeTeamMatches.count, 0, "Home Team should not be nil")
                    XCTAssertEqual(nilAwayIteamMatches.count, 0, "Away Team Team should not be nil")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 4)
    }
}
