//
//  ContentView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                Tab("Explore", systemImage: "magnifyingglass") {
                    ExploreView()
                }

                Tab("Wishlists", systemImage: "heart") {
                    WishlistsView()
                }

                Tab("Trips", systemImage: "airplane") {
                    TripsView()
                }

                Tab("Inbox", systemImage: "envelope") {
                    InboxView()
                }

                Tab("Profile", systemImage: "person") {
                    ProfileView()
                }
            }
            .tint(.primary60)
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

struct InboxView: View {
    var body: some View {
        Text("Inbox View")
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
}
