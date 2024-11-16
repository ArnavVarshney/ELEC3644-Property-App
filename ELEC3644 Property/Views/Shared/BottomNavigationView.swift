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
        let _ = print(userViewModel.currentUserId())
        let _ = print(userViewModel.isLoggedIn())
        TabView {
            if userViewModel.userRole == .host {
                ListingView()
                    .tabItem({
                        Label("Listings", systemImage: "house")
                    })
            } else {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                WishlistsView()
                    .tabItem {
                        Label("Wishlists", systemImage: "heart.fill")
                    }
            }
            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "envelope")
                }
            ProfileView()
                .tabItem {
                    Label(userViewModel.isLoggedIn() ? "Profile" : "Login", systemImage: "person")
                }

        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .tint(.black)
    }
}

#Preview {
    struct MenuItemList_Preview: View {
        var body: some View {
            BottomNavigationView()
                .environmentObject(UserViewModel(user: Mock.Users[0]))
                .environmentObject(PropertyViewModel())
                .environmentObject(InboxViewModel())
        }
    }

    return MenuItemList_Preview()
}
