//
//  Team.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation

struct TeamData: ResponseModel {
    let teams: [Team]
}

struct Team: ResponseModel {
    let id: String
    let name: String
    let logo: URL?
}
