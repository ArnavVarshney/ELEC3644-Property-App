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
    @Published var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    ))
    @Published var places: [MKMapItem] = []
    
    var property: Property
    
    init(property: Property) {
        self.property = property
        geocodeAddress()
    }
    
    func geocodeAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(property.address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first, let marker = placemark.location {
                self.location = marker.coordinate
                self.position = .region(MKCoordinateRegion(
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
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                if let response = response {
                    self.places += response.mapItems
                }
            }
        }
    }
    
    func poiIcon(for category: MKPointOfInterestCategory?) -> String {
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
}
