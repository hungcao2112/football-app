//
//  MockTeam.swift
//  football-app-tests
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation

@testable import football_app

func mockTeams() -> [Team] {
    [
        Team(
            id: UUID().uuidString,
            name: "Home 1",
            logo: URL(string: "https://tstzj.s3.amazonaws.com/dragons.png")
        ),
        Team(
            id: UUID().uuidString,
            name: "Away 1",
            logo: URL(string: "https://tstzj.s3.amazonaws.com/dragons.png")
        ),
        Team(
            id: UUID().uuidString,
            name: "Home 2",
            logo: URL(string: "https://tstzj.s3.amazonaws.com/dragons.png")
        ),
        Team(
            id: UUID().uuidString,
            name: "Away 2",
            logo: URL(string: "https://tstzj.s3.amazonaws.com/dragons.png")
        )
    ]
}


