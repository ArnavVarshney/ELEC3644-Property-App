//
//  ExploreView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

struct ExploreView: View {
    @State private var searchText: String = ""
    @State private var currentMenu: MenuItem? = MenuItem.buy
    @State private var isSearchActive: Bool = false

    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @EnvironmentObject private var agentViewModel: AgentViewModel
    @EnvironmentObject private var userViewModel: UserViewModel

    func queryString(properties: [Property], query: String) -> [Property] {
        return properties.filter({ property in
            if query.isEmpty {
                return true
            } else {
                return property.name.contains(query)
                    || property.address.contains(query)
                    || property.district.contains(query)
                    || property.schoolNet.primary.contains(query)
                    || property.schoolNet.secondary.contains(query)
            }
        })
    }

    var body: some View {
        NavigationStack() {
            VStack(spacing: 0){
                VStack {
                    SearchBarView(searchText: $searchText, isActive: $isSearchActive)
                    MenuItemListView(selectedMenu: $currentMenu)
                }
                .background(.white)
                .shadow(color: .neutral100.opacity(0.1), radius: 1, x: 0, y: 1)
                .sheet(isPresented: $isSearchActive) {
                    SearchFieldsView(currentMenu: currentMenu)
                }
                ZStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ListingMenuView(
                                properties: queryString(
                                    properties: propertyViewModel.getByContractType(
                                        contractType: "Buy"), query: searchText)
                            )
                            .id(MenuItem.buy)
                            .frame(width: UIScreen.main.bounds.width)
                            ListingMenuView(
                                properties: queryString(
                                    properties: propertyViewModel.getByContractType(
                                        contractType: "Rent"), query: searchText)
                            )
                            .id(MenuItem.rent)
                            .frame(width: UIScreen.main.bounds.width)
                            ListingMenuView(
                                properties: queryString(
                                    properties: propertyViewModel.getByContractType(
                                        contractType: "Lease"), query: searchText)
                            )
                            .id(MenuItem.lease)
                            .frame(width: UIScreen.main.bounds.width)
                            TransactionMenuView(properties: propertyViewModel.properties)
                                .id(MenuItem.transaction)
                                .frame(width: UIScreen.main.bounds.width)
                            AgentMenuView()
                                .id(MenuItem.agents)
                                .frame(width: UIScreen.main.bounds.width)
                            EnlargeMapView_V2(
                                startMapCameraLocation: .customLocation(
                                    latitude: 22.3193, longitude: 114.1694)
                            )
                            .id(MenuItem.map)
                            .frame(width: UIScreen.main.bounds.width)

                        }
                    }
                    .scrollPosition(id: $currentMenu)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollDisabled(true)
                }
            }
            
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
