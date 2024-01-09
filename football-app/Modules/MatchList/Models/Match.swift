//
//  Match.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation

enum MatchPhase {
    case previous
    case upcoming
    
    var title: String {
        switch self {
        case .previous:
            "Previous Matches"
        case .upcoming:
            "Upcoming Matches"
        }
    }
}

public struct MatchListData: ResponseModel {
    let matches: MatchList
}

public struct MatchList: ResponseModel {
    let previous: [Match]
    let upcoming: [Match]
}

public struct Match: ResponseModel, Equatable, Hashable {
    let uuid: String = UUID().uuidString
    let date: Date?
    let description: String
    let home: String
    let away: String
    let winner: String?
    let highlights: URL?
    
    var homeTeam: Team?
    var awayTeam: Team?
    
    enum CodingKeys: String, CodingKey {
        case date, description, home, away, winner, highlights
    }
    
    public static func == (lhs: Match, rhs: Match) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct GroupedMatch: Equatable, Hashable {
    let date: Date?
    let matches: [Match]
}
