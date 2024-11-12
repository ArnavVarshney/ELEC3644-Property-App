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

    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(searchText: $searchText, isActive: $isSearchActive)
                MenuItemListView(selectedMenu: $currentMenu)
            }
            .padding(.bottom, 12)
            .sheet(isPresented: $isSearchActive) {
                SearchFieldsView(currentMenu: currentMenu)
                    .presentationDetents([.height(620)])
            }

            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        BuyMenuView(properties: propertyViewModel.properties)
                            .id(MenuItem.buy)
                            .frame(width: geometry.size.width)
                        RentMenuView()
                            .id(MenuItem.rent)
                            .frame(width: geometry.size.width)
                        LeaseMenuView()
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
}
