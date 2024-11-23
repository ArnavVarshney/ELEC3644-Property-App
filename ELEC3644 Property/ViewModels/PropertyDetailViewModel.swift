//
//  PropertyDetailViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import MapKit
import SwiftUI

class PropertyDetailViewModel: ObservableObject {
    @Published var location: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    @Published var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            latitudinalMeters: 8000,
            longitudinalMeters: 8000
        ))
    @Published var places: [MKMapItem] = []  // array storing
    @Published var property: Property
    @Published var transactions: [Transaction]
    init(property: Property) {
        self.property = property
        transactions = property.transactionHistory
        geocodeAddress()
    }

    func geocodeAddress() {  // recieve address, get address, have the correct longitude
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(property.address), \(property.subDistrict)") {
            placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first, let marker = placemark.location {
                self.location = marker.coordinate
                self.position = .region(
                    MKCoordinateRegion(
                        center: marker.coordinate,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    ))
                self.performSearch()
            }
        }
    }

    func performSearch() {
        let request = MKLocalSearch.Request()
        let queries = ["hospital", "transportation", "food", "school"]
        for query in queries {
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            let search = MKLocalSearch(request: request)  // search is like a list or collection
            search.start { response, _ in
                if let response = response {
                    self.places += response.mapItems
                }
            }
        }
    }

    static func poiIcon(for category: MKPointOfInterestCategory?) -> String {
        switch category {
        case .hospital:
            return "cross.fill"
        case .school:
            return "graduationcap"
        case .publicTransport:
            return "bus"
        case .restaurant:
            return "fork.knife"
        default:
            return "mappin.circle.fill"
        }
    }

    static func threeClosestByCategory(
        from category: MKPointOfInterestCategory, currentLocation: CLLocationCoordinate2D,
        places: [MKMapItem]
    ) -> [MKMapItem] {
        let filteredPlaces = places.filter { $0.pointOfInterestCategory == category }
        let sortedPlaces = filteredPlaces.sorted { item1, item2 -> Bool in
            let distance1 = PropertyDetailViewModel.distance(
                from: currentLocation, to: item1.placemark.coordinate
            )
            let distance2 = PropertyDetailViewModel.distance(
                from: currentLocation, to: item2.placemark.coordinate
            )
            return distance1 < distance2
        }
        return Array(sortedPlaces.prefix(3))
    }

    static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
        -> CLLocationDistance
    {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) / 1000
    }

    static func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> String {
        let distance = PropertyDetailViewModel.distance(from: from, to: to)
        return String(format: "%.2f", distance) + " km"
    }
}
