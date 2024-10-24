//
//  MapView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import MapKit
import SwiftUI

struct PropertyDetailMapView: View {
  @StateObject var viewModel: PropertyDetailViewModel

  var body: some View {
    VStack {
      Map(position: $viewModel.position) {
        Marker("Here!", coordinate: viewModel.location)
        ForEach(viewModel.places, id: \.self) { place in
          Marker(
            place.placemark.name ?? "POI",
            systemImage: PropertyDetailViewModel.poiIcon(for: place.pointOfInterestCategory),
            coordinate: place.placemark.coordinate
          )
        }
      }
      .frame(height: 280)

      Divider()

      PropertyDetailNearestListView(title: "Hospitals", category: .hospital, viewModel: viewModel)
      PropertyDetailNearestListView(title: "Schools", category: .school, viewModel: viewModel)
      PropertyDetailNearestListView(
        title: "Restaurants", category: .restaurant, viewModel: viewModel)
      PropertyDetailNearestListView(
        title: "Transportations", category: .publicTransport, viewModel: viewModel)

      Divider()
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  struct PropertyDetailMapView_Preview: View {
    @StateObject var propertyViewModel = PropertyViewModel()
    @StateObject var propertyDetailViewModel: PropertyDetailViewModel

    init() {
      self._propertyDetailViewModel = StateObject(
        wrappedValue: PropertyDetailViewModel(property: Mock.Properties[0]))
    }

    var body: some View {
      PropertyDetailMapView(
        viewModel: propertyDetailViewModel
      ).environmentObject(propertyViewModel)
    }
  }

  return PropertyDetailMapView_Preview()
}
