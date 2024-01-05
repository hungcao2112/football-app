//
//  APIService.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation
import Combine

protocol APIService {
    func fetchData<T: ResponseModel>(with endpoint: String, responseType: T.Type) -> AnyPublisher<T, Error>
}

class BaseAPIService: APIService {
    func fetchData<T: ResponseModel>(with endpoint: String, responseType: T.Type) -> AnyPublisher<T, Error> {
        let baseURL = URL(string: APIConstants.baseURL)!
        let url = baseURL.appendingPathComponent(endpoint)

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: T.decoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class BaseService {
    let apiService: APIService
    
    init(apiService: APIService = DependencyContainer.shared.apiService) {
        self.apiService = apiService
    }
}
