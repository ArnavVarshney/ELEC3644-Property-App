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
                ForEach(properties) { property in
                    NavigationLink(destination: PropertyDetailView(property: property)) {
                        PropertyCardView(property: property)
                    }
                }
            }
        }
        .refreshable {
            await refreshData()
        }
    }

    func refreshData() async {
        await viewModel.fetchProperties()
    }
}

#Preview {
    struct ListingMenuView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            ListingMenuView(properties: viewModel.getByContractType(contractType: "buying"))
                .environmentObject(UserViewModel())
        }
    }
    return ListingMenuView_Preview()
        .environmentObject(PropertyViewModel())
}
