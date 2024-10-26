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
  struct PropertyCardListView_Preview: View {
    @EnvironmentObject var viewModel: PropertyViewModel
    var body: some View {
      PropertyCardListView(properties: Mock.Properties)
    }
  }
  return PropertyCardListView_Preview()
    .environmentObject(PropertyViewModel())
}
