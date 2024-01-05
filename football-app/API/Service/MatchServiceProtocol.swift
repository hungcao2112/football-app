//
//  MatchServiceProtocol.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation
import Combine

protocol MatchServiceProtocol {
    func fetchMatches() -> AnyPublisher<MatchList, Error>
}
