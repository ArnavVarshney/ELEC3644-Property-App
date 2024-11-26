//
//  PropertyViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class PropertyViewModel: ObservableObject {
    private let apiClient: APIClient
    @Published var properties: [Property] = []
    private var propertyLocations: [String: CLLocationCoordinate2D] = [:]
    private var propertyMapItems: [UUID: MKMapItem] = [:]

    private var cancellables = Set<AnyCancellable>()

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
            await geocodePropertiesAddresses(fetchedProperties)
        } catch {
            print("Error fetching property data: \(error)")
        }
    }

    func postProperty<T: Encodable>(data: [String: T]) async {
        do {
            let _: [String: String] = try await apiClient.post(url: "/wishlists", body: data)
        } catch {
            print("Error fetching property data: \(error)")
        }
    }

    func postProperty<T: Encodable>(id: String, data: [String: T]) async {
        do {
            let _: [String: String] = try await apiClient.post(url: "/wishlists", body: data)
        } catch {
            print("Error fetching property data: \(error)")
        }
    }

    func query(query: [String: String]) async {
        do {
            let fetchedProperties: [Property] = try await apiClient.post(
                url: "/properties/query", body: query)
            DispatchQueue.main.async {
                self.properties = fetchedProperties
            }
        } catch {
            print("Error fetching queried properties: \(error)")
        }
    }

    private func geocodePropertiesAddresses(_ properties: [Property]) async {
        let geocoder = CLGeocoder()

        for property in properties {
            if let location = await geocodeAddress(geocoder, address: property.address) {
                propertyLocations[property.name] = location
                let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
                let propertyMapItem = MKMapItem(placemark: placemark)
                propertyMapItems[property.id] = propertyMapItem
            } else {
                print("Could not geocode address for \(property.name): \(property.address)")
            }
        }
    }

    private func geocodeAddress(_ geocoder: CLGeocoder, address: String) async
        -> CLLocationCoordinate2D?
    {
        return await withCheckedContinuation { continuation in
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    print("Geocoding error for address \(address): \(error)")
                    continuation.resume(returning: nil)
                    return
                }

                if let location = placemarks?.first?.location?.coordinate {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    func getByContractType(contractType: String) -> [Property] {
        return properties.filter { $0.contractType == contractType }
    }

    func getLocation(for propertyName: String) -> CLLocationCoordinate2D? {
        return propertyLocations[propertyName]
    }

    func getMapItem(for propertyId: UUID) -> MKMapItem? {
        return propertyMapItems[propertyId]
    }

    func getByAgent(agentId: String) -> [Property] {
        return properties.filter { $0.agent.id == UUID(uuidString: agentId) }
    }
}
