//
//  PropertySearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//

import SwiftUI

struct PropertySearchFieldsView: View {
    @State private var priceRange: Double = 500000
    @State private var bedrooms: Int = 1
    @State private var bathrooms: Int = 1
    @State private var propertyType: String = "Any"
    @State private var amenities: Set<String> = []

    let propertyTypes = ["Any", "House", "Apartment", "Townhouse", "Villa"]
    let amenitiesList = ["Parking", "Pool", "Gym", "Elevator", "Balcony", "Pet-friendly"]

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Property Type")
                    .font(.headline)
                Picker("Property Type", selection: $propertyType) {
                    ForEach(propertyTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            VStack {
                Text("Price Range")
                    .font(.headline)
                IntSlider(range: $priceRange, bottomRange: 0, topRange: 1000000, step: 1000)
                Stepper(value: $bedrooms, in: 1...10) {
                    Text("\(bedrooms) bedroom(s)")
                }
                Stepper(value: $bathrooms, in: 1...10) {
                    Text("\(bathrooms) bathroom(s)")
                }
            }
            VStack {
                Text("Amenities")
                    .font(.headline)
                ChipGrid(items: amenitiesList, selectedItems: $amenities)
            }
        }
    }
}

#Preview {
    PropertySearchFieldsView()
}
