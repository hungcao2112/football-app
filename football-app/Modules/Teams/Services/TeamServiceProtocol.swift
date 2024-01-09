//
//  TeamServiceProtocol.swift
//  football-app
//
//  Created by Hung Cao on 06/01/2024.
//

import Foundation
import Combine

protocol TeamServiceProtocol {
    func fetchTeams() -> AnyPublisher<[Team], Error>
}
