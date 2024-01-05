//
//  DependencyContainer.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()

    lazy var apiService: APIService = BaseAPIService()

    private init() {}
}
