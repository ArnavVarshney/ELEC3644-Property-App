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
    @State private var showpointSearchView = false
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @EnvironmentObject private var agentViewModel: AgentViewModel
    var body: some View {
        NavigationStack {
            VStack {
                //                SearchBarView(searchText: $searchText, isActive: $isSearchActive)
                SearchAndFilterBarView(isActive: $isSearchActive)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            showpointSearchView.toggle()
                        }
                    }
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
                                    contractType: "Buy")
                            )
                            .id(MenuItem.buy)
                            .frame(width: geometry.size.width)
                            ListingMenuView(
                                properties: propertyViewModel.getByContractType(
                                    contractType: "Rent")
                            )
                            .id(MenuItem.rent)
                            .frame(width: geometry.size.width)
                            ListingMenuView(
                                properties: propertyViewModel.getByContractType(
                                    contractType: "Lease")
                            )
                            .id(MenuItem.lease)
                            .frame(width: geometry.size.width)
                            TransactionMenuView(properties: propertyViewModel.properties)
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
                    NavigationLink(
                        destination: EnlargeMapView_V2(
                            currentMenu: $currentMenu,
                            startMapCameraLocation: .customLocation(
                                latitude: 22.3193, longitude: 114.1694)
                        )
                        .environmentObject(propertyViewModel)
                    ) {
                        HStack {
                            Image(systemName: "map")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .symbolEffect(.pulse, options: .speed(0.75))
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
            .sheet(isPresented: $showpointSearchView) {
                pointSearchView(show: $showpointSearchView, currentMenu: $currentMenu)
                    .presentationDetents([.height(800)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(800)))
                    .presentationCornerRadius(30)
                    .interactiveDismissDisabled(true)
            }
        }
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
}
