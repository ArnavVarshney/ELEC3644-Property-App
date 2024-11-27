//
//  ListingListView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//
import SwiftUI

struct ListingListView: View {
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    let properties: [Property]
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(properties) { property in
                    NavigationLink(destination: PropertyDetailView(property: property)) {
                        ListingCardView(property: property)
                            .padding(.bottom, 24)
                    }
                }
            }
        }
        .refreshable {
            propertyViewModel.initTask()
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
