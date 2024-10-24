//
//  BottomNavigationView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 13/10/2024.
//

import SwiftUI

struct BottomNavigationView: View {
  var body: some View {
    TabView {
      ExploreView()
        .tabItem {
          Label("Explore", systemImage: "magnifyingglass")
        }
      WishlistsView()
        .tabItem {
          Label("Wishlists", systemImage: "heart.fill")
        }
      TripsView()
        .tabItem {
          Label("Trips", systemImage: "airplane")
        }
      InboxView()
        .tabItem {
          Label("Inbox", systemImage: "envelope")
        }
      ProfileView()
        .tabItem {
          Label("Profile", systemImage: "person")
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
        .environmentObject(UserViewModel())
        .environmentObject(PropertyViewModel())
        .environmentObject(InboxViewModel())
    }
  }

  return MenuItemList_Preview()
}
