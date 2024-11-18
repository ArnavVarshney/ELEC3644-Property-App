//
//  BubblePropertyViewModel.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 18/11/2024.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class PropertyViewModelWithLocation: ObservableObject {
    private let apiClient: APIClient
    @Published var properties: [Property] = []
    private var propertyLocations: [String: CLLocationCoordinate2D] = [:]  // Dictionary to hold locations by name
    private var propertyMapItems: [UUID: MKMapItem] = [:] // New dictionary for MKMapItem for properties[]

    private var cancellables = Set<AnyCancellable>()

    init(apiClient: APIClient = NetworkManager.shared) {
        self.apiClient = apiClient
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
            // Geocode addresses after fetching properties
            await geocodePropertiesAddresses(fetchedProperties)

        } catch {
            print("Error fetching properties: \(error)")
        }
    }

    private func geocodePropertiesAddresses(_ properties: [Property]) async {
        let geocoder = CLGeocoder()

        for property in properties {
            if let location = await geocodeAddress(geocoder, address: property.address) {
                propertyLocations[property.name] = location  // Store the location using property name
                // Create MKMapItem and store it in the mapItems dictionary
                let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
                let propertyMapItem = MKMapItem(placemark: placemark)
                propertyMapItems[property.id] = propertyMapItem // Store the propertyMapItem using property name
            } else {
                print("Could not geocode address for \(property.name): \(property.address)")
            }
        }

        // Optionally, you can publish an update or notify observers here if needed.
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

    func getLocation(for propertyName: String) -> CLLocationCoordinate2D? {  //retreive the CLLocationcoor2D if exist
        return propertyLocations[propertyName]
    }
    
    func getMapItem(for propertyId: UUID) -> MKMapItem? { // Retrieve the MKMapItem if it exists
        return propertyMapItems[propertyId]
        }

}
