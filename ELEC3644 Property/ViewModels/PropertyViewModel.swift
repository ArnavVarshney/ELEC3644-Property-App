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
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        guard let url = Bundle.main.url(forResource: "properties", withExtension: "json") else {
            print("User data file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(df)

            self.properties = try decoder.decode([Property].self, from: data)
        } catch {
            print("Error decoding user data: \(error)")
        }
    }
}
