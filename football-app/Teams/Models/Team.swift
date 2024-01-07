//
//  Team.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation

public struct TeamData: ResponseModel {
    let teams: [Team]
}

public struct Team: ResponseModel, Equatable, Hashable {
    let id: String
    let name: String
    let logo: URL?
    
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo
    }
}
