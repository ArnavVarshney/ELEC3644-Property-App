//
//  PropertySearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct PropertySearchFieldsView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel

    let propertyTypes = ["any", "house", "apartment", "townhouse", "villa"]
    let amenitiesList = ["parking", "pool", "gym", "elevator", "balcony", "pet-friendly"]
    let priceRange: ClosedRange<Double> = 0...100_000_000

    func onSubmit() {
        var requestBody = [String: String]()
        let searchFields = viewModel.searchFields
        requestBody["netPrice"] = "([\"min\": lowerPrice, \"max\": upperPrice])"
        requestBody["propertyType"] = "\(searchFields.propertyType)".lowercased()
        requestBody["amenities"] = "\(Array(searchFields.amenities))"
        requestBody["area"] = "\(searchFields.area)"
        requestBody["district"] = "\(searchFields.district)"
        requestBody["subDistrict"] = "\(searchFields.subdistrict)"
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
                        Picker("Property Type", selection: $viewModel.searchFields.propertyType) {
                            ForEach(propertyTypes, id: \.self) {
                                Text(LocalizedStringKey($0.capitalized)).tag($0)
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
                            Text(
                                "Min: \(Int(viewModel.searchFields.lowerPrice).toCompactCurrencyFormat())"
                            )
                            Slider(
                                value: $viewModel.searchFields.lowerPrice, in: priceRange,
                                step: 1000
                            )
                            .onChange(of: viewModel.searchFields.lowerPrice) { _, newValue in
                                if newValue > viewModel.searchFields.upperPrice {
                                    viewModel.searchFields.lowerPrice =
                                        viewModel.searchFields.upperPrice
                                }
                            }
                        }

                        VStack {
                            Text(
                                "Max: \(Int(viewModel.searchFields.upperPrice).toCompactCurrencyFormat())"
                            )
                            Slider(
                                value: $viewModel.searchFields.upperPrice, in: priceRange,
                                step: 1000
                            )
                            .onChange(of: viewModel.searchFields.upperPrice) { _, newValue in
                                if newValue < viewModel.searchFields.lowerPrice {
                                    viewModel.searchFields.upperPrice =
                                        viewModel.searchFields.lowerPrice
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
                            Picker("Area", selection: $viewModel.searchFields.area) {
                                Text("Any").tag("any")
                                ForEach(Location.areas, id: \.self) {
                                    Text(LocalizedStringKey($0))
                                }
                            }.pickerStyle(.menu)
                        }
                        HStack {
                            Text("District")
                            Spacer()
                            Picker("District", selection: $viewModel.searchFields.district) {
                                Text("Any").tag("any")
                                ForEach(
                                    Location.districts[viewModel.searchFields.area] ?? [],
                                    id: \.self
                                ) {
                                    Text(LocalizedStringKey($0))
                                }
                            }
                            .disabled(viewModel.searchFields.area == "any")
                            .onChange(of: viewModel.searchFields.area) { oldValue, newValue in
                                if newValue != oldValue {
                                    viewModel.searchFields.district = "any"
                                }
                            }
                        }
                        HStack {
                            Text("Subdistrict")
                            Spacer()
                            Picker("Subdistrict", selection: $viewModel.searchFields.subdistrict) {
                                Text("Any").tag("any")
                                ForEach(
                                    Location.subDistricts[viewModel.searchFields.district] ?? [],
                                    id: \.self
                                ) {
                                    Text(LocalizedStringKey($0))
                                }
                            }
                            .disabled(viewModel.searchFields.district == "any")
                            .onChange(of: viewModel.searchFields.area) { oldValue, newValue in
                                if newValue != oldValue {
                                    viewModel.searchFields.district = "any"
                                }
                            }
                            .onChange(of: viewModel.searchFields.district) { oldValue, newValue in
                                if newValue != oldValue {
                                    viewModel.searchFields.subdistrict = "any"
                                }
                            }

                        }
                    }
                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amenities")
                            .fontWeight(.semibold)
                            .padding(.bottom, 4)
                        ChipGrid(
                            items: amenitiesList, selectedItems: $viewModel.searchFields.amenities)
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
