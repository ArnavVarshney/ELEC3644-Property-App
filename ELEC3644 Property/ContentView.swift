//
//  ContentView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            BottomNavigationView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(InboxViewModel())
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
