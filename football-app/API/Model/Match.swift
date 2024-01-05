//
//  Match.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation

struct MatchListData: ResponseModel {
    let matches: MatchList
}

struct MatchList: ResponseModel {
    let previous: [Match]
    let upcoming: [Match]
}

struct Match: ResponseModel {
    let date: Date?
    let description: String
    let home: String
    let away: String
    let winner: String?
    let highlights: URL?
}
