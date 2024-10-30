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
            }

            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        BuyMenuView(properties: propertyViewModel.properties)
                            .id(MenuItem.buy)
                            .frame(width: geometry.size.width)
                        AgentMenuView()
                            .id(MenuItem.agents)
                            .frame(width: geometry.size.width)
                        ForEach(MenuItem.allCases, id: \.self) { menuItem in
                            Text(menuItem.rawValue)
                                .id(menuItem.rawValue)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
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

#Preview {
    ExploreView()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
