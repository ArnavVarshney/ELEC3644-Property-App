//
//  BottomNavigationView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 13/10/2024.
//
import SwiftUI

struct BottomNavigationView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        TabView {
            if userViewModel.userRole != .guest {
                ListingView().tabItem { Label("Listings", systemImage: "house") }
                TransactionListView().tabItem {
                    Label("Transactions", systemImage: "dollarsign.bank.building")
                }
            } else {
                ExploreView().tabItem { Label("Explore", systemImage: "magnifyingglass") }
                WishlistsView().tabItem { Label("Wishlists", systemImage: "heart.fill") }
            }
            InboxView().tabItem { Label("Inbox", systemImage: "envelope") }
            ProfileView()
                .tabItem {
                    Label(userViewModel.isLoggedIn() ? "Profile" : "Log in", systemImage: "person")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .tint(.neutral100)
    }
}

#Preview {
    struct MenuItemList_Preview: View {
        var body: some View {
            BottomNavigationView().environmentObject(UserViewModel(user: Mock.Users[0]))
                .environmentObject(PropertyViewModel()).environmentObject(InboxViewModel())
                .environmentObject(AgentViewModel())
        }
    }
    return MenuItemList_Preview()
}

struct TransactionListView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var propertyViewModel: PropertyViewModel

    var body: some View {
        NavigationStack {
            TransactionMenuView(
                properties: propertyViewModel.properties.filter({ property in
                    property.agent.id == UUID(uuidString: userViewModel.currentUserId())
                })
            )
            .navigationTitle("Transactions")
        }
    }
}
