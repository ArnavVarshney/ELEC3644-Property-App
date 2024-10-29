//
//  EnlargeMapView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 27/10/2024.
//

import MapKit
import SwiftUI

struct EnlargeMapView: View {
    //@Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PropertyDetailViewModel
    @Binding var showEnlargeMapView: Bool
    @State var popUp: Bool = true

    var body: some View {

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
                    .frame(width: 125, height: 25)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        Capsule()
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 2)
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
            // Back Button
            Button {
                showEnlargeMapView.toggle()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.black)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                    }
                    .padding(.top, 20)
                    .padding(.leading, 35)
            }
            VStack {
                Spacer()
                Image(systemName: "clock")
                Spacer()

                MapPopUpView(property: viewModel.property, popUp: $popUp)
                    .padding(30)
                    .frame(minHeight: 10, maxHeight: 300)
            }
            //.edgesIgnoringSafeArea(.bottom)  // Optional: ignore safe area if desired
            .frame(alignment: .bottom)
        }
        //        .backButton()
        //        .ignoresSafeArea()
        //        .toolbarBackground(.hidden, for: .navigationBar)
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
