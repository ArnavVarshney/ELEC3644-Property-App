//
//  MapSearchFieldView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 27/11/2024.
//

import SwiftUI

struct MapSearchFieldView: View {
    @State private var lowerPrice: Double = 100_000
    @State private var upperPrice: Double = 500_000
    @State private var contractType: String = "Buy"  //Default contractType: "Buy"

    @State private var amenities: Set<String> = []
    @EnvironmentObject private var viewModel: PropertyViewModel

    let contractTypes = ["Buy", "Rent", "Lease"]
    let amenitiesList = ["parking", "pool", "gym", "elevator", "balcony", "pet-friendly"]
    let priceRange: ClosedRange<Double> = 0...100_000_000
    func onSubmit() {
        var requestBody = [String: String]()
        let searchFields = viewModel.searchFields
        requestBody["contractType"] = contractType
        requestBody["minNetPrice"] = "\(Int(searchFields.lowerPrice))"
        requestBody["maxNetPrice"] = "\(Int(searchFields.upperPrice))"
        Task {
            await viewModel.query(query: requestBody)
        }
        for property in viewModel.properties {
            print(property.netPrice)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
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
                        HStack {
                            Text("Contract Type")
                            Spacer()
                            Picker("contract type", selection: $contractType) {
                                //
                                //                                if contractType == "Buy" {
                                //                                    Text("Buy").tag("Buy")
                                //                                }
                                ForEach(contractTypes, id: \.self) { c in
                                    Text(c).tag(c)
                                }
                            }.pickerStyle(.automatic)
                        }

                        //                        HStack {
                        //                            Text("Contract Type")
                        //                            Spacer()
                        //                            Picker("Contract Type", selection: $contractType) {
                        //                                ForEach(contractTypes, id: \.self) { c in
                        //                                    Text(c).tag(c) // Use the actual string as the tag
                        //                                }
                        //                            }
                        //                            .pickerStyle(.menu)
                        //                        }
                        //                        .padding()
                    }
                    Divider()

                }
                Spacer()
                Divider()
                BottomBar(onSubmit: onSubmit)
            }
        }
    }
}

#Preview {
    MapSearchFieldView()
}
