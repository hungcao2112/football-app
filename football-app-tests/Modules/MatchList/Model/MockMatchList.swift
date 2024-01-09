//
//  MockMatchList.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation

@testable import football_app

func mockMatchList() -> MatchList {
    MatchList(
        previous: mockPreviousMatches(),
        upcoming: mockUpcomingMatches()
    )
}
