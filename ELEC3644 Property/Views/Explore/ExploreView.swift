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
    @State private var showENlargeMpaView_V2: Bool = false
    //    @State private var showpointSearchView = false

    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @EnvironmentObject private var agentViewModel: AgentViewModel

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
        NavigationStack {
            VStack {
                SearchBarView(searchText: $searchText, isActive: $isSearchActive)
                MenuItemListView(selectedMenu: $currentMenu)
            }
            .padding(.bottom, 12)
            .sheet(isPresented: $isSearchActive) {
                SearchFieldsView(currentMenu: currentMenu)
            }
            ZStack {
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ListingMenuView(
                                properties: queryString(
                                    properties: propertyViewModel.getByContractType(
                                        contractType: "Buy"), query: searchText)
                            )
                            .id(MenuItem.buy)
                            .frame(width: geometry.size.width)
                            ListingMenuView(
                                properties: queryString(
                                    properties: propertyViewModel.getByContractType(
                                        contractType: "Rent"), query: searchText)
                            )
                            .id(MenuItem.rent)
                            .frame(width: geometry.size.width)
                            ListingMenuView(
                                properties: queryString(
                                    properties: propertyViewModel.getByContractType(
                                        contractType: "Lease"), query: searchText)
                            )
                            .id(MenuItem.lease)
                            .frame(width: geometry.size.width)
                            TransactionMenuView(properties: propertyViewModel.properties)
                                .id(MenuItem.transaction)
                                .frame(width: geometry.size.width)
                            EstateMenuView(properties: propertyViewModel.properties)
                                .id(MenuItem.estate)
                                .frame(width: geometry.size.width)
                            AgentMenuView()
                                .id(MenuItem.agents)
                                .frame(width: geometry.size.width)
                        }
                    }
                    .scrollPosition(id: $currentMenu)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollDisabled(true)
                }
                VStack {
                    Spacer()

                    if currentMenu?.rawValue == "Buy" || currentMenu?.rawValue == "Rent"
                        || currentMenu?.rawValue == "Lease"
                    {
                        Button(action: {
                            showENlargeMpaView_V2 = true
                        }) {
                            HStack {
                                Image(systemName: "map")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .symbolEffect(.variableColor)
                                    .padding(.leading, 16)
                                Text("Map")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .padding(.trailing, 16)
                                    .addShadow()
                            }
                            .background(.black)
                            .cornerRadius(36)
                            .padding(.vertical, 24)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                        }
                    }
                }
                .sheet(isPresented: $showENlargeMpaView_V2) {
                    EnlargeMapView_V2(
                        currentMenu: $currentMenu,
                        startMapCameraLocation: .customLocation(
                            latitude: 22.3193, longitude: 114.1694)
                    )
                    .environmentObject(propertyViewModel)
                    .presentationDetents([.height(700)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(700)))
                    .presentationCornerRadius(24)
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
