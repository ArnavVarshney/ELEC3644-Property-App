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
    @EnvironmentObject var viewModel: PropertyViewModelWithLocation
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
                                properties: propertyViewModel.getByContractType(
                                    contractType: "buying")
                            )
                            .id(MenuItem.buy)
                            .frame(width: geometry.size.width)
                            ListingMenuView(
                                properties: propertyViewModel.getByContractType(
                                    contractType: "renting")
                            )
                            .id(MenuItem.rent)
                            .frame(width: geometry.size.width)
                            ListingMenuView(
                                properties: propertyViewModel.getByContractType(
                                    contractType: "leasing")
                            )
                            .id(MenuItem.lease)
                            .frame(width: geometry.size.width)
                            TransactionMenuView()
                                .id(MenuItem.transaction)
                                .frame(width: geometry.size.width)
                            EstateMenuView()
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
                    NavigationLink(destination: EnlargeMapView_V2(currentMenu: $currentMenu).environmentObject(viewModel)) {
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
        }
    }
}

struct RentMenuView: View {
    var body: some View {
        Text("Rent")
    }
}

struct LeaseMenuView: View {
    var body: some View {
        Text("Lease")
    }
}

struct TransactionMenuView: View {
    var body: some View {
        Text("Transaction")
    }
}

struct EstateMenuView: View {
    var body: some View {
        Text("Estate")
    }
}

#Preview {
    ExploreView()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
        .environmentObject(PropertyViewModelWithLocation())
}
