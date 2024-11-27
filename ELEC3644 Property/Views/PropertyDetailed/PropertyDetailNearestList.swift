//
//  PropertyDetailNearestList.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import MapKit
import SwiftUI

struct PropertyDetailNearestListView: View {
    var title: String
    var category: MKPointOfInterestCategory
    var viewModel: PropertyDetailViewModel
    var pois: [MKMapItem] = []
    @State private var visible = false

    init(title: String, category: MKPointOfInterestCategory, viewModel: PropertyDetailViewModel) {
        self.title = title
        self.category = category
        self.viewModel = viewModel
        self.pois = PropertyDetailViewModel.threeClosestByCategory(
            from: category, currentLocation: viewModel.location, places: viewModel.places
        )
        if self.pois.count > 0 { self.visible = true }
    }

    var body: some View {
        Divider()
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.neutral100)
                .padding(.bottom, 8)
            ForEach(
                pois,
                id: \.self
            ) { place in
                HStack {
                    Text(place.placemark.name ?? "poi")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(
                        "\(PropertyDetailViewModel.getDistance(from: place.placemark.coordinate, to: viewModel.location))"
                    )
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    struct PropertyDetailNearestListView_Preview: View {
        @StateObject var propertyViewModel = PropertyViewModel()
        @StateObject var propertyDetailViewModel: PropertyDetailViewModel
        init() {
            self._propertyDetailViewModel = StateObject(
                wrappedValue: PropertyDetailViewModel(property: Mock.Properties[0]))
        }

        var body: some View {
            PropertyDetailNearestListView(
                title: "Hospitals",
                category: .hospital,
                viewModel: propertyDetailViewModel
            ).environmentObject(propertyViewModel)
        }
    }
    return PropertyDetailNearestListView_Preview()
}
