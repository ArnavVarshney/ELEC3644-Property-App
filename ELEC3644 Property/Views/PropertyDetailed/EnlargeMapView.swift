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
        NavigationStack {
            ZStack(alignment: .center) {
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
                        .frame(width: 125, height: 25)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            Capsule()
                                .stroke(lineWidth: 0.5)
                                .foregroundColor(.white)
                                .addShadow()
                                .clipShape(RoundedRectangle(cornerRadius: 1))
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
                .mapControlVisibility(.hidden)

                VStack(alignment: .center) {
                    Spacer()

                    if popUp {
                        MapPopUpView(property: viewModel.property, popUp: $popUp)
                            .frame(height: 270)
                            .padding(.bottom, 35)
                            .padding(.horizontal, 20)
                    }

                    Button {
                        popUp.toggle()  // Show the PopUpView
                    } label: {
                        Image(systemName: popUp ? "xmark" : "plus")  // Display xmark when popUp is true
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.bottom)
                        //.padding(.leading, 20)
                    }
                }

            }
            .backButton()
        }
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
                .environmentObject(propertyViewModel)
                .environmentObject(UserViewModel())
        }
    }
    return EnlargeMapView_Preview()
}
