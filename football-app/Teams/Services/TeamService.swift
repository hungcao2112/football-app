//
//  TeamService.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation
import Combine

class TeamService: BaseService, TeamServiceProtocol {
    func fetchTeams() -> AnyPublisher<[Team], Error> {
        return apiService.fetchData(
            with: "teams",
            responseType: TeamData.self
        )
        .map(\.teams)
        .eraseToAnyPublisher()
    }
}
