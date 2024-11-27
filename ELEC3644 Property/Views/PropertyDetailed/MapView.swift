//
//  MapView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 27/10/2024.
//
import MapKit
// this is just a part of PropertyDetailMapView --> PropertyDetailView
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: PropertyDetailViewModel
    @Binding var showEnlargeMapView: Bool
    var body: some View {
        VStack {
            Map(position: $viewModel.position) {
                Annotation(viewModel.property.name, coordinate: viewModel.location) {
                    HStack {
                        Text(String(viewModel.property.netPrice))
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(Color.neutral100)
                        Text("HKD")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(Color.neutral100)
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
                    .onTapGesture {
                        withAnimation(.spring()) { showEnlargeMapView.toggle() }
                    }
                }
                .annotationTitles(.visible)
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
            .frame(height: 280)
        }
    }
}

#Preview {
    struct MapView_Preview: View {
        @StateObject var propertyViewModel = PropertyViewModel()
        @StateObject var propertyDetailViewModel: PropertyDetailViewModel
        @State private var showEnlargeMapView = false
        init() {
            self._propertyDetailViewModel = StateObject(
                wrappedValue: PropertyDetailViewModel(property: Mock.Properties[0]))
        }

        var body: some View {
            MapView(showEnlargeMapView: $showEnlargeMapView)
                .environmentObject(propertyDetailViewModel)
        }
    }
    return MapView_Preview()
}
