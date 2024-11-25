//
//  EstateMenuView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 23/11/2024.
//

import SwiftUI

struct Estate {
    var name: String
    var properties: [Property]
    var transactions: [PropertyTransaction] = []
    var averagePrice: Int = 0
    var averageArea: Int = 0
    var averagePricePerSqFt: Int = 0
}

struct EstateMenuView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel

    var properties: [Property]
    var estates: [Estate] = []

    init(properties: [Property]) {
        self.properties = properties
        self.estates = getEstates()
    }

    private func getEstates() -> [Estate] {
        var estates: [Estate] = []
        for property in properties {
            if let idx = estates.firstIndex(where: { $0.name == property.estate }) {
                estates[idx].properties.append(property)
                estates[idx].averagePrice += property.netPrice
                estates[idx].averageArea += property.saleableArea
                continue
            } else {
                let estate = Estate(
                    name: property.estate,
                    properties: [property],
                    averagePrice: property.netPrice,
                    averageArea: property.saleableArea
                )
                estates.append(estate)
            }
        }
        for (idx, estate) in estates.enumerated() {
            estates[idx].transactions = estate.properties.getTransactions()
            estates[idx].averagePrice /= estate.properties.count
            estates[idx].averageArea /= estate.properties.count
            estates[idx].averagePricePerSqFt = estate.averagePrice / estate.averageArea
        }
        return estates
    }

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(estates, id: \.name) { estate in
                        NavigationLink(destination: EstateDetailedView(estate: estate)) {
                            EstateRowView(estate: estate)
                        }
                        Divider()
                    }
                }
            }
            .refreshable {
                viewModel.initTask()
            }
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    struct EstateMenuView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            EstateMenuView(properties: viewModel.properties)
                .environmentObject(UserViewModel())
        }
    }
    return EstateMenuView_Preview()
        .environmentObject(PropertyViewModel())
}

struct EstateRowView: View {
    let estate: Estate

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(estate.name) ・ \(estate.properties.first?.address ?? "")")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.neutral100)
                .multilineTextAlignment(.leading)
            Text(
                "\(estate.properties.first?.district ?? ""), \(estate.properties.first?.area ?? "")"
            )
            .font(.subheadline)
            .foregroundColor(.neutral60)
            HStack(alignment: .center) {
                Text(
                    "S.A. \(estate.averageArea)sqft @ \(estate.averagePricePerSqFt.toCompactCurrencyFormat())/sqft"
                )
                .font(.subheadline)
                .foregroundColor(.neutral60)
                Spacer()
            }
            .padding(.bottom, 4)
            HStack {
                ForEach(["Buy", "Rent", "Lease"], id: \.self) { contractType in
                    Text(
                        "\(estate.properties.filter { $0.contractType == contractType }.count) \(contractType)"
                    )
                    .font(.subheadline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(.neutral100)
                    .cornerRadius(4)
                    .foregroundColor(.neutral10)
                }
            }
        }
        .padding(.vertical)
    }
}

struct EstateDetailedView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel
    let estate: Estate

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(estate.properties, id: \.self) { property in
                    NavigationLink(destination: PropertyDetailView(property: property)) {
                        PropertyRowView(property: property)
                    }
                }
            }
            .refreshable {
                viewModel.initTask()
            }
        }
        .padding(.horizontal)
    }
}

struct PropertyRowView: View {
    let property: Property

    var body: some View {
        HStack {

            AsyncImage(url: URL(string: property.imageUrls[0])) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 114, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding(.trailing, 4)
            Spacer()
            VStack(alignment: .leading) {
                Text("\(property.name)")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.neutral100)
                HStack(alignment: .center) {
                    Text(
                        property.netPrice.toCompactCurrencyFormat()
                    )
                    .font(.subheadline)
                    .foregroundColor(.neutral60)
                    Spacer()
                }
                HStack {
                    Text(property.contractType)
                        .font(.subheadline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.neutral100)
                        .cornerRadius(4)
                        .foregroundColor(.neutral10)
                    Spacer()
                }
            }
        }
    }
}
