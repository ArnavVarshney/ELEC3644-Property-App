//
//  ContentView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        BottomNavigationView()
    }
}

#Preview {
    ContentView()
        .environmentObject(InboxViewModel())
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel(user: Mock.Users[0]))
        .environmentObject(AgentViewModel())
        .environmentObject(LocationManager())
        .environmentObject(LanguageSetting())
        .environmentObject(MapSettingsViewModel())
}
