//
//  TeamListTests.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation
import Combine
import XCTest
@testable import football_app

class TeamListTests: XCTestCase {
    var viewModel: TeamListViewModel!
    let teamService = MockTeamService()
    
    private var cancellables = Set<AnyCancellable>()
    
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
}

// MARK: - Methods

extension TeamListTests {
    func testFetchTeamsSuccess() {
        // Given
        viewModel = TeamListViewModel(
            teams: [],
            service: teamService
        )
        let expectation = expectation(description: "Team list fetched and decoded successfully")
        
        // When
        viewModel.fetchData()
        
        // Then
        viewModel.$teams
            .receive(on: RunLoop.main)
            .dropFirst(1)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { teams in
                XCTAssertNotEqual(teams.count, 0, "Team list should not be empty")
                for team in teams {
                    XCTAssertNotEqual(team.id, "", "Team id should not be empty")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
