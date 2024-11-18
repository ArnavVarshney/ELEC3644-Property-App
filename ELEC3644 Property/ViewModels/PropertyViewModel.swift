//
//  PropertyViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import Foundation

class PropertyViewModel: ObservableObject {
    private let apiClient: APIClient
    @Published var properties: [Property] = []
    init(apiClient: APIClient = NetworkManager.shared) {
        self.apiClient = apiClient
        initTask()
    }

    func initTask() {
        Task {
            await fetchProperties()
        }
    }

    func fetchProperties() async {
        do {
            let fetchedProperties: [Property] = try await apiClient.get(url: "/properties")
            DispatchQueue.main.async {
                self.properties = fetchedProperties
            }
        } catch {
            print("Error fetching property data: \(error)")
        }
    }

    func getByContractType(contractType: String) -> [Property] {
        return properties.filter { $0.contractType == contractType }
    }
    
    func query(query: [String: String]) async {
        do {
            let fetchedProperties: [Property] = try await apiClient.post(url: "/properties/query", body: query)
            DispatchQueue.main.async {
                self.properties = fetchedProperties
            }
        } catch {
            print("Error fetching queried properties: \(error)")
        }
    }
}
