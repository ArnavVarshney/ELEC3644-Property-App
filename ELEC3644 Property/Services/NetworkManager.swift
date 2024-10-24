//
//  NetworkManager.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 24/10/24.
//

import Foundation

protocol APIClient {
  func get<T: Decodable>(url: URL) async throws -> T
  func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
  func patch<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
}

class NetworkManager: APIClient {
  private let urlCache: URLCache
  private let decoder = JSONDecoder()

  init(urlCache: URLCache = .shared) {
    self.urlCache = urlCache
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    self.decoder.dateDecodingStrategy = .formatted(df)
  }

  func get<T: Decodable>(url: URL) async throws -> T {
//    if let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
//      let decodedData = try self.decoder.decode(T.self, from: cachedResponse.data)
//      return decodedData
//    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
      let cachedResponse = CachedURLResponse(response: response, data: data)
      urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }

    let decodedData = try self.decoder.decode(T.self, from: data)
    return decodedData
  }

  func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(body)

    let (data, _) = try await URLSession.shared.data(for: request)
    let decodedData = try self.decoder.decode(T.self, from: data)
    return decodedData
  }

  func patch<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(body)

    let (data, _) = try await URLSession.shared.data(for: request)
    let decodedData = try self.decoder.decode(T.self, from: data)
    return decodedData
  }
}
