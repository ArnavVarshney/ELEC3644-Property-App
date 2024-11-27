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
    @State private var contractType: String = "Any"

    @State private var amenities: Set<String> = []
    @EnvironmentObject private var viewModel: PropertyViewModel

    let contractTypes = ["Buy", "Rent", "Lease"]
    let amenitiesList = ["parking", "pool", "gym", "elevator", "balcony", "pet-friendly"]
    let priceRange: ClosedRange<Double> = 0...1_000_000

    //    func onSubmit() {
    //        var requestBody = [String: String]()
    //        requestBody["contractType"] = contractType
    //        requestBody["netPrice"] = "([\"min\": lowerPrice, \"max\": upperPrice])"
    //        Task {
    //            await viewModel.query(query: requestBody)
    //        }
    //    }
    //
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
                        Text("Price Range")
                            .fontWeight(.semibold)
                            .padding(.bottom, 4)
                            .font(.headline)

                        VStack {
                            Text("Min: \(Int(viewModel.searchFields.lowerPrice))")
                            Slider(
                                value: $viewModel.searchFields.lowerPrice, in: priceRange,
                                step: 1000
                            )
                            .onChange(of: lowerPrice) { _, newValue in
                                if newValue > upperPrice {
                                    lowerPrice = upperPrice
                                }
                            }
                        }

                        VStack {
                            Text("Max: \(Int(viewModel.searchFields.upperPrice))")
                            Slider(
                                value: $viewModel.searchFields.upperPrice, in: priceRange,
                                step: 1000
                            )
                            .onChange(of: upperPrice) { _, newValue in
                                if newValue < lowerPrice {
                                    upperPrice = lowerPrice
                                }
                            }
                        }
                        HStack {
                            Text("Contract Type")
                            Spacer()
                            Picker("contract type", selection: $contractType) {
                                if contractType == "Any" {
                                    Text("Any").tag("Any")
                                }
                                ForEach(contractTypes, id: \.self) { c in
                                    Text(c).tag(c.lowercased())
                                }
                            }.pickerStyle(.menu)
                        }
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
