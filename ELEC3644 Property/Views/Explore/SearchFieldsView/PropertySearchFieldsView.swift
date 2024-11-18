//
//  PropertySearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct PropertySearchFieldsView: View {
    @State private var lowerPrice: Double = 100_000
    @State private var upperPrice: Double = 500_000
    @State private var propertyType: String = "Any"

    @State private var area: String = "Any"
    @State private var district: String = "Any"
    @State private var subdistrict: String = "Any"

    @State private var amenities: Set<String> = []
    @EnvironmentObject private var viewModel: PropertyViewModel
    
    let propertyTypes = ["Any", "House", "Apartment", "Townhouse", "Villa"]
    let amenitiesList = ["parking", "pool", "gym", "elevator", "balcony", "pet-friendly"]
    let priceRange: ClosedRange<Double> = 0...1_000_000
    
    func onSubmit() {
        var requestBody = [String: String]()
        requestBody["netPrice"] = "([\"min\": lowerPrice, \"max\": upperPrice])"
        requestBody["propertyType"] = "\(propertyType)".lowercased()
        requestBody["amenities"] = "\(Array(amenities))"
        requestBody["area"] = "\(area)"
        requestBody["district"] = "\(district)"
        requestBody["subDistrict"] = "\(subdistrict)"
        
        Task {
            await viewModel.query(query: requestBody)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
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
                        
                        VStack {
                            Text("Min: \(Int(lowerPrice))")
                            Slider(value: $lowerPrice, in: priceRange, step: 1000)
                                .onChange(of: lowerPrice) { _, newValue in
                                    if newValue > upperPrice {
                                        lowerPrice = upperPrice
                                    }
                                }
                        }
                        
                        VStack {
                            Text("Max: \(Int(upperPrice))")
                            Slider(value: $upperPrice, in: priceRange, step: 1000)
                                .onChange(of: upperPrice) { _, newValue in
                                    if newValue < lowerPrice {
                                        upperPrice = lowerPrice
                                    }
                                }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .fontWeight(.semibold)
                            .padding(.bottom, 4)
                        HStack {
                            Text("Area")
                            Spacer()
                            Picker("Area", selection: $area) {
                                if area == "Any" {
                                    Text("Any").tag("Any")
                                }
                                ForEach(Location.areas, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                        }
                        HStack {
                            Text("District")
                            Spacer()
                            Picker("District", selection: $district) {
                                if district == "Any" {
                                    Text("Any").tag("Any")
                                }
                                ForEach(Location.districts[area] ?? [], id: \.self) {
                                    Text($0)
                                }
                            }
                            .disabled(area == "Any")
                        }
                        HStack {
                            Text("Subdistrict")
                            Spacer()
                            Picker("Subdistrict", selection: $subdistrict) {
                                if district == "Any" {
                                    Text("Any").tag("Any")
                                }
                                ForEach(Location.subDistricts[district] ?? [], id: \.self) {
                                    Text($0)
                                }
                            }
                            .disabled(district == "Any")
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
                Spacer()
                Divider()
                BottomBar(onSubmit: onSubmit)
            }
        }
    }
}

#Preview {
    PropertySearchFieldsView()
}
