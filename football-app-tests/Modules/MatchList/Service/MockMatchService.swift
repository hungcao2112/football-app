//
//  MockMatchService.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation
import Combine
import XCTest

@testable import football_app

class MockMatchService: MatchServiceProtocol {
    func fetchMatches() -> AnyPublisher<football_app.MatchList, Error> {
        let matchList = mockMatchList()
        return Just(matchList)
            .delay(for: 2, scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
