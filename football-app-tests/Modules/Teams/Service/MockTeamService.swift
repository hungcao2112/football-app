//
//  MockTeamService.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation
import Combine

@testable import football_app

class MockTeamService: TeamServiceProtocol {
    func fetchTeams() -> AnyPublisher<[football_app.Team], Error> {
        let teams = mockTeams()
        return Just(teams)
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
