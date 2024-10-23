//
//  PropertyDetailView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import MapKit
import SwiftUI

struct PropertyDetailView: View {
  var property: Property
  @ObservedObject var viewModel: PropertyDetailViewModel

  init(property: Property) {
    self.property = property
    self.viewModel = .init(property: property)
  }

  var body: some View {
    VStack {
      ScrollView {
        PropertyImageView()
        PropertyDetailListView(viewModel: viewModel)
        PropertyDetailMapView(viewModel: viewModel)
        PropertyDetailGraphView(viewModel: viewModel)
        Spacer()
      }
      .ignoresSafeArea()
      PropertyDetailBottomBarView(viewModel: viewModel)
    }
    .backButton()
    .toolbarBackground(.hidden, for: .navigationBar)
  }
}

#Preview {
  struct PropertyDetail_Preview: View {
    @EnvironmentObject var propertyViewModel: PropertyViewModel
    var body: some View {
      PropertyDetailView(property: propertyViewModel.properties[0])
    }
  }
  return PropertyDetail_Preview()
    .environmentObject(PropertyViewModel())
}
