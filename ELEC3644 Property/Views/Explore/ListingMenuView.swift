//
//  ListingMenuView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

struct ListingMenuView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel

    let properties: [Property]
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                if !properties.isEmpty {
                    ForEach(properties) { property in
                        NavigationLink(destination: PropertyDetailView(property: property)) {
                            PropertyCardView(property: property)
                                .padding(.top, 24)

                        }
                    }
                } else {
                    HStack {
                        Text("Oops!!! Please refresh this view.")
                            .font(.headline)
                    }
                    .padding()
                    .frame(width: 400, height: 300)

                }
            }
        }
        .refreshable {
            viewModel.initTask()
        }
    }
}

#Preview {
    struct ListingMenuView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            ListingMenuView(properties: viewModel.getByContractType(contractType: "Buy"))
                .environmentObject(UserViewModel())
        }
    }
    return ListingMenuView_Preview()
        .environmentObject(PropertyViewModel())
}
