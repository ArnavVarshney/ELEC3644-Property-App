//
//  ListingView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//

import SwiftUI

struct ListingView: View {
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @EnvironmentObject private var agentViewModel: AgentViewModel

    var body: some View {
        NavigationStack {
            VStack {
                BuyMenuView(properties: propertyViewModel.properties)
                    .id(MenuItem.buy)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .navigationTitle("Your listings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Add new listing")
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            }
        }

    }
}

#Preview {
    ListingView()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
