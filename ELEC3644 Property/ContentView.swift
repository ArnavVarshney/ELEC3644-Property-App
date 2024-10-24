//
//  ContentView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      ZStack {
        BottomNavigationView()
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    .environmentObject(PropertyViewModel())
    .environmentObject(UserViewModel())
  }
}

struct WishlistsView: View {
  var body: some View {
    Text("Wishlists View")
      .font(.largeTitle)
      .padding()
      .navigationTitle("Wishlists")
  }
}

struct TripsView: View {
  var body: some View {
    Text("Trips View")
      .font(.largeTitle)
      .padding()
      .navigationTitle("Trips")
  }
}

#Preview {
  ContentView()
    .environmentObject(InboxViewModel())
    .environmentObject(PropertyViewModel())
    .environmentObject(UserViewModel())
}
