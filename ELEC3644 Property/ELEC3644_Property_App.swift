//
//  ELEC3644_Property_AppApp.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

@main
struct ELEC3644_Property_App: App {
  @StateObject var inboxData = InboxViewModel()
  @StateObject var userData = UserViewModel()
  @StateObject var propertyData = PropertyViewModel()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(inboxData)
        .environmentObject(userData)
        .environmentObject(propertyData)
    }
  }
}
