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
                PropertyDetails(property: $viewModel.property)
                MapView(location: $viewModel.location, position: $viewModel.position, places: $viewModel.places, poiIcon: viewModel.poiIcon)
                Spacer()
            }
            .ignoresSafeArea()
            PropertyDetailBottomBarView(property: $viewModel.property)
        }
        .backButton()
    }
}

struct PropertyImageView: View {
    var body: some View {
        TabView {
            ForEach(1 ..< 6) { _ in
                Image("Property1")
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page)
        .frame(height: 310)
        .padding(.bottom, 4)
    }
}

struct PropertyDetails: View {
    @Binding var property: Property

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HeaderView(property: property)
            Divider()
            DetailRows(details: propertyDetails())
            Divider()
        }
        .padding(.horizontal, 24)
    }

    private func propertyDetails() -> [(String, String)] {
        return [
            ("Estate", property.estate),
            ("Saleable Area", "\(property.saleableArea)"),
            ("Saleable Area/Sqft", "\(property.saleableAreaPricePerSquareFoot)"),
            ("Gross Floor Area", "\(property.grossFloorArea)"),
            ("Gross Floor Area/Sqft", "\(property.grossFloorAreaPricePerSquareFoot)"),
            ("Primary School Net", property.schoolNet.primary),
            ("Secondary School Net", property.schoolNet.secondary),
            ("Building Age", "\(property.buildingAge)"),
            ("Building Direction", property.buildingDirection)
        ]
    }
}

struct HeaderView: View {
    let property: Property

    var body: some View {
        VStack(alignment: .leading) {
            Text(property.name)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.neutral100)
                .padding(.bottom, 1)
            Text("\(property.address), \(property.subDistrict)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.neutral100)
            Text("\(property.district), \(property.area)")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.neutral70)
        }
    }
}



#Preview {
    struct PropertyDetail_Preview: View {
        private var property = Property(
            name: "Grandview Garden - 1E",
            address: "8 Nam Long Shan Road",
            area: "HK Island",
            district: "Central and Western",
            subDistrict: "Sheung Wan",
            facilities: [
                Facility(desc: "mtr", measure: 8, measureUnit: "min(s)")
            ],
            schoolNet: SchoolNet(
                primary: "11",
                secondary: "Central and Western District"
            ),
            saleableArea: 305,
            saleableAreaPricePerSquareFoot: 14262,
            grossFloorArea: 417,
            grossFloorAreaPricePerSquareFoot: 10432,
            netPrice: "7.4M",
            buildingAge: 39,
            buildingDirection: "South East",
            estate: "Grandview Garden"
        )
        var body: some View {
            PropertyDetailView(property: property)
        }
    }
    return PropertyDetail_Preview()
}
