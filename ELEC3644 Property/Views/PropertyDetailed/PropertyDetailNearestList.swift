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
    @StateObject var viewModel: PropertyDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.neutral100)
                .padding(.bottom, 8)
            ForEach(PropertyDetailViewModel.threeClosestByCategory(from: category, currentLocation: viewModel.location, places: viewModel.places), id: \.self) { place in
                HStack {
                    Text(place.placemark.name ?? "poi")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral70)
                        .padding(.bottom, 2)
                    Spacer()
                    Text("\(PropertyDetailViewModel.getDistance(from: place.placemark.coordinate, to: viewModel.location))")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral100)
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
            let propertyViewModel = PropertyViewModel()
            self._propertyDetailViewModel = StateObject(wrappedValue: PropertyDetailViewModel(property: propertyViewModel.properties.first!))
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
