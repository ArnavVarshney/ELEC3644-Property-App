//
//  ContentView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: BottomNavigation = .explore
    var body: some View {
        ZStack {
            NavigationStack {
                selectedTab.destinationView
                    .toolbar(.hidden, for: .tabBar)
                    .toolbarBackground(.hidden, for: .tabBar)
            }

            VStack {
                Spacer()
                BottomNavigationView(selectedNavigation: $selectedTab)
            }
        }
    }
}

struct WishlistsView: View {
    var body: some View {
        Text("Wishlists View")
            .font(.largeTitle)
            .padding()
    }
}

struct TripsView: View {
    var body: some View {
        Text("Trips View")
            .font(.largeTitle)
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(Inbox())
}
