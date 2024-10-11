//
//  PropertyCardListView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct PropertyCardListView: View {
    let properties: [Property]

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(properties) { property in
                    NavigationLink(destination: PropertyDetailView(property: property)) {
                        PropertyCardView(property: property)
                    }
                }
            }
        }
    }
}

#Preview {
    PropertyCardListView(properties: properties)
}
