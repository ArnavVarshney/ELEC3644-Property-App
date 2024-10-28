//
//  ContentView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct ContentView: View {
  @StateObject var inboxData = InboxViewModel()
  @StateObject var userData = UserViewModel()
  @StateObject var propertyData = PropertyViewModel()
  var body: some View {
    NavigationView {
      ZStack {
        BottomNavigationView()
      }
      .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    .environmentObject(propertyData)
    .environmentObject(userData)
  }
}

#Preview {
  ContentView()
    .environmentObject(InboxViewModel())
    .environmentObject(PropertyViewModel())
    .environmentObject(UserViewModel())
}
