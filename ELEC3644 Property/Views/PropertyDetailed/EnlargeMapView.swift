//
//  EnlargeMapView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 27/10/2024.
//

import MapKit
import SwiftUI

struct EnlargeMapView: View {

  @EnvironmentObject var viewModel: PropertyDetailViewModel
  @Binding var showEnlargeMapView: Bool

  var body: some View {
    VStack {
      ZStack(alignment: .topLeading) {
        // The Map
        Map(position: $viewModel.position) {
          // Annotation for the target property
          Annotation(viewModel.property.name, coordinate: viewModel.location) {
            HStack {
              Text(viewModel.property.netPrice)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
              Text("HKD")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            }
            .padding(.horizontal, 1)
            .padding(.vertical, 1)
            .cornerRadius(2)
            .background(Color.white)
            .overlay(
              Capsule()
                .stroke(lineWidth: 0.5)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2)
            )
          }
          .annotationTitles(.visible)

          // Markers for other places
          ForEach(viewModel.places, id: \.self) { place in
            Marker(
              place.placemark.name ?? "POI",
              systemImage: PropertyDetailViewModel.poiIcon(for: place.pointOfInterestCategory),
              coordinate: place.placemark.coordinate
            )
          }
        }
        // Back Button
        Button(action: {
          withAnimation(.spring()) {
            showEnlargeMapView.toggle()  // Toggle the binding to close the view
          }
        }) {
          HStack {
            Image(systemName: "chevron.left")  // Back arrow icon
              .foregroundColor(.white)
            //.backButton()
            Text("Back")
              .foregroundColor(.white)
              .fontWeight(.semibold)
          }
          .padding()
          .background(Color.black.opacity(0.7))  // Background for the button
          .cornerRadius(10)  // Rounded corners for the button
        }
        .padding(.vertical, 30)  // Padding around the button

      }
    }
    .backButton()
    .ignoresSafeArea()
    .toolbarBackground(.visible, for: .navigationBar)
    .overlay(alignment: .bottom) {
      VStack {
        Divider()
          .padding(.bottom)
        MapPopUpView(property: viewModel.property)
          .padding()
      }
    }
  }
}

#Preview {
  struct EnlargeMapView_Preview: View {
    @StateObject var propertyViewModel = PropertyViewModel()
    @StateObject var propertyDetailViewModel = PropertyDetailViewModel(property: Mock.Properties[0])
    @State private var showEnlargeMapView = false

    var body: some View {
      EnlargeMapView(showEnlargeMapView: $showEnlargeMapView)
        .environmentObject(propertyViewModel)
    }
  }

  return EnlargeMapView_Preview()
}
