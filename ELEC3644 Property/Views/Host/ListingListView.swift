//
//  ListingListView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//

import SwiftUI

struct ListingListView: View {
    let properties: [Property]

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(properties) { property in
                    NavigationLink(destination: PropertyDetailView(property: property)) {
                        ListingCardView(property: property)
                    }
                }
            }
        }
    }
}

#Preview {
    struct ListingListViewPreview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            ListingListView(properties: Mock.Properties)
                .environmentObject(UserViewModel())
        }
    }
    return ListingListViewPreview()
        .environmentObject(PropertyViewModel())
}
