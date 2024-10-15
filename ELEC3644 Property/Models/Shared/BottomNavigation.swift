//
//  BottomNavigation.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 13/10/2024.
//

import SwiftUI

enum BottomNavigation: String, CaseIterable {
    case explore = "Explore"
    case wishlists = "Wishlists"
    case trips = "Trips"
    case inbox = "Inbox"
    case profile = "Profile"

    var systemImage: String {
        switch self {
        case .explore:
            return "magnifyingglass"
        case .wishlists:
            return "heart"
        case .trips:
            return "airplane"
        case .inbox:
            return "envelope"
        case .profile:
            return "person"
        }
    }

    var destinationView: some View {
        switch self {
        case .explore:
            return AnyView(ExploreView())
        case .wishlists:
            return AnyView(WishlistsView())
        case .trips:
            return AnyView(TripsView())
        case .inbox:
            return AnyView(InboxView())
        case .profile:
            return AnyView(ProfileView())
        }
    }
}
