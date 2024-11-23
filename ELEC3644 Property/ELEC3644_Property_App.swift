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
    @StateObject var locationManager = LocationManager()
    @StateObject var languageSetting = LanguageSetting()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(inboxData)
                .environmentObject(userData)
                .environmentObject(propertyData)
                .environmentObject(agentData)
                .environmentObject(locationManager)
                .environmentObject(languageSetting)
                .environment(\.locale, languageSetting.locale)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
