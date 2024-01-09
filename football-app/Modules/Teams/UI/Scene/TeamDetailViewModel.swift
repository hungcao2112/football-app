//
//  TeamDetailViewModel.swift
//  football-app
//
//  Created by Hung Cao on 07/01/2024.
//

import Foundation
import Combine

class TeamDetailViewModel {
    private var team: Team
    
    @Published var imageUrl: URL?
    @Published var teamName: String? = ""
    
    var title: String
    
    init(team: Team) {
        self.team = team
        self.title = "Team Detail"
        self.configureData()
    }
}

// MARK: - Configure Data

extension TeamDetailViewModel {
    func configureData() {
        imageUrl = team.logo
        teamName = team.name
    }
}
