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
    @State var popUp: Bool = true

    var body: some View {

        ZStack {
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
                        systemImage: PropertyDetailViewModel.poiIcon(
                            for: place.pointOfInterestCategory),
                        coordinate: place.placemark.coordinate
                    )
                }
            }
            // Back Button
            VStack {
                Spacer()
                Image(systemName: "clock")
                Spacer()

                MapPopUpView(property: viewModel.property, popUp: $popUp)
                    .padding(30)
            }
            .edgesIgnoringSafeArea(.bottom)  // Optional: ignore safe area if desired
            .frame(alignment: .bottom)
        }
        .backButton()
        .ignoresSafeArea()
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    struct EnlargeMapView_Preview: View {
        @StateObject var propertyViewModel = PropertyViewModel()
        @StateObject var propertyDetailViewModel = PropertyDetailViewModel(
            property: Mock.Properties[0])
        @State private var showEnlargeMapView = false

        var body: some View {
            EnlargeMapView(showEnlargeMapView: $showEnlargeMapView)
                .environmentObject(propertyDetailViewModel)
        }
    }

    return EnlargeMapView_Preview()
}
