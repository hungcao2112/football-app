//
//  MatchService.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation
import Combine

class MatchService: BaseService, MatchServiceProtocol {
    func fetchMatches() -> AnyPublisher<MatchList, Error> {
        return apiService.fetchData(
            with: "teams/matches",
            responseType: MatchListData.self
        )
        .map(\.matches)
        .eraseToAnyPublisher()
    }
}
