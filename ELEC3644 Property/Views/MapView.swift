//
//  MapView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Binding var location: CLLocationCoordinate2D
    @Binding var position: MapCameraPosition
    @Binding var places: [MKMapItem]
    var poiIcon: (MKPointOfInterestCategory?) -> String

    var body: some View {
        Map(position: $position) {
            Marker("Here!", coordinate: location)
            ForEach(places, id: \.self) { place in
                Marker(place.placemark.name ?? "POI", systemImage: poiIcon(place.pointOfInterestCategory), coordinate: place.placemark.coordinate)
            }
        }
        .frame(height: 280)
        .padding(.horizontal, 24)
    }
}
