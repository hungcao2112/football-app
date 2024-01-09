//
//  MockMatch.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation

@testable import football_app

func mockPreviousMatches() -> [Match] {
    [
        Match(
            date: Date().advanced(by: -86400),
            description: "Mock previous match 1",
            home: "Home 1",
            away: "Away 1",
            winner: "Away 1",
            highlights: URL(string: "https://tstzj.s3.amazonaws.com/highlights.mp4")
        ),
        Match(
            date: Date().advanced(by: -86400),
            description: "Mock previous match 2",
            home: "Home 2",
            away: "Away 2",
            winner: "Home 2",
            highlights: URL(string: "https://tstzj.s3.amazonaws.com/highlights.mp4")
        ),
    ]
}

func mockUpcomingMatches() -> [Match] {
    [
        Match(
            date: Date().advanced(by: 86400),
            description: "Mock upcoming match 1",
            home: "Home 1",
            away: "Away 1",
            winner: "Away 1",
            highlights: URL(string: "https://tstzj.s3.amazonaws.com/highlights.mp4")
        ),
        Match(
            date: Date().advanced(by: 86400),
            description: "Mock upcoming match 2",
            home: "Home 2",
            away: "Away 2",
            winner: "Home 2",
            highlights: URL(string: "https://tstzj.s3.amazonaws.com/highlights.mp4")
        ),
    ]
}
