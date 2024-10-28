//
//  MapView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import MapKit
import SwiftUI

struct PropertyDetailMapView: View {
  @EnvironmentObject var viewModel: PropertyDetailViewModel
  @State private var showEnlargeMapView = false

  var body: some View {
    VStack {
      MapView(showEnlargeMapView: $showEnlargeMapView)
        .environmentObject(viewModel)
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
    .fullScreenCover(
      isPresented: $showEnlargeMapView,
      content: {
        EnlargeMapView(showEnlargeMapView: $showEnlargeMapView)
          .environmentObject(viewModel)
      })
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
      PropertyDetailMapView().environmentObject(propertyDetailViewModel)
    }
  }

  return PropertyDetailMapView_Preview()
}
