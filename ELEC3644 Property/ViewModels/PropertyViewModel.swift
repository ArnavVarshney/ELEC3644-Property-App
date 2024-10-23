//
//  PropertyViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

class PropertyViewModel: ObservableObject {
  @Published var properties: [Property] = []

  init() {
    Task {
      await fetchProperties()
    }
  }

  func fetchProperties() async {
    do {
      let fetchedProperties = try await PropertyViewModel.getProperties()
      DispatchQueue.main.async {
        self.properties = fetchedProperties
      }
    } catch {
      print("Error fetching user data: \(error)")
    }
  }

  static func getProperties() async throws -> [Property] {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"

    guard let url = URL(string: "https://chat-server.home-nas.xyz/properties") else {
      throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw URLError(.badServerResponse)
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(df)
    return try decoder.decode([Property].self, from: data)
  }
}
