//
//  Model.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import Foundation

protocol Model {
  static func decoder() -> JSONDecoder
  static func encoder() -> JSONEncoder
}

// MARK: - Decodable

extension Model where Self: Decodable {
  static func decoder() -> JSONDecoder {
    return JSONDecoder()
  }

  static func decode(_ data: Data) throws -> Self {
    return try decoder().decode(self, from: data)
  }

  static func decode(_ dictionary: [String: Any]) throws -> Self {
    return try decode(try JSONSerialization.data(withJSONObject: dictionary))
  }
}


// MARK: - APIModel

protocol APIModel: Model {}

extension APIModel {
    static func decoder() -> JSONDecoder {
      let d = JSONDecoder()
      d.dateDecodingStrategy = .formatted(.iso8601)
      d.keyDecodingStrategy = .convertFromSnakeCase
      return d
    }

    static func encoder() -> JSONEncoder {
      let e = JSONEncoder()
      e.dateEncodingStrategy = .formatted(.iso8601)
      e.keyEncodingStrategy = .convertToSnakeCase
      return e
    }
}

// MARK: - Response Model

protocol ResponseModel: APIModel, Codable {}
