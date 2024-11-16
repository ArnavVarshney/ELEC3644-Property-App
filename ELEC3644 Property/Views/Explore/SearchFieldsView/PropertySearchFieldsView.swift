//
//  PropertySearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct PropertySearchFieldsView: View {
    @State private var priceRange: Double = 500_000
    @State private var bedrooms: Int = 1
    @State private var bathrooms: Int = 1
    @State private var propertyType: String = "Any"
    @State private var amenities: Set<String> = []
    let propertyTypes = ["Any", "House", "Apartment", "Townhouse", "Villa"]
    let amenitiesList = ["Parking", "Pool", "Gym", "Elevator", "Balcony", "Pet-friendly"]
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Property Type")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                Picker("Property Type", selection: $propertyType) {
                    ForEach(propertyTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Price Range")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                    .font(.headline)
                IntSlider(range: $priceRange, bottomRange: 0, topRange: 1_000_000, step: 1000)
                Stepper(value: $bedrooms, in: 1...10) {
                    Text("\(bedrooms) bedroom(s)")
                }
                Stepper(value: $bathrooms, in: 1...10) {
                    Text("\(bathrooms) bathroom(s)")
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Amenities")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                ChipGrid(items: amenitiesList, selectedItems: $amenities)
            }
        }
    }
}

#Preview {
    PropertySearchFieldsView()
}
