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
    @StateObject var mapSettingsViewModel = MapSettingsViewModel()
    @State var showResetPassword = false
    @State var userId = ""

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
                .environmentObject(mapSettingsViewModel)
                .environment(\.locale, languageSetting.locale)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    if url.absoluteString.contains("reset-password") {
                        showResetPassword = true
                        userId = url.lastPathComponent
                        print("Reset password for user: \(userId)")

                    }
                }
                .sheet(isPresented: $showResetPassword) {
                    ResetPasswordView(userId: userId)
                        .presentationDetents([.medium])
                }
        }
    }
}
