//
//  ELEC3644_Property_App.swift
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
    @StateObject var agentData = AgentViewModel()
    @StateObject var propertyWithLocationData = PropertyViewModelWithLocation()
    @StateObject var locationManager = LocationManager()
    @StateObject var languageSetting = LanguageSetting()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(inboxData)
                .environmentObject(userData)
                .environmentObject(propertyData)
                .environmentObject(agentData)
                .environmentObject(propertyWithLocationData)
                .environmentObject(locationManager)
                .environmentObject(languageSetting)
                .environment(\.locale, languageSetting.locale)
        }
    }
}
