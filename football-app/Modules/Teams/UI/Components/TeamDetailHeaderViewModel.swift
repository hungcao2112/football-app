//
//  TeamDetailHeaderViewModel.swift
//  football-app
//
//  Created by Hung Cao on 09/01/2024.
//

import Foundation

class TeamDetailHeaderViewModel {
    private var team: Team
    
    var imageUrl: URL?
    var teamName: String? = ""
    
    init(team: Team) {
        self.team = team
        self.configureData()
    }
}

// MARK: - Configure Data

extension TeamDetailHeaderViewModel {
    func configureData() {
        imageUrl = team.logo
        teamName = team.name
    }
}
