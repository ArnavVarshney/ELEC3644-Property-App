//
//  PropertyDetailListView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import SwiftUI

struct PropertyDetailListView: View {
  @StateObject var viewModel: PropertyDetailViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      PropertyDetailHeaderView(property: viewModel.property)
      Divider()
      PropertyDetailRowsView(details: propertyDetails())
      Divider()
    }
    .padding(.horizontal, 24)
  }

  private func propertyDetails() -> [(String, String)] {
    return [
      ("Estate", viewModel.property.estate),
      ("Saleable Area", "\(viewModel.property.saleableArea)"),
      ("Saleable Area/Sqft", "\(viewModel.property.saleableAreaPricePerSquareFoot)"),
      ("Gross Floor Area", "\(viewModel.property.grossFloorArea)"),
      ("Gross Floor Area/Sqft", "\(viewModel.property.grossFloorAreaPricePerSquareFoot)"),
      ("Primary School Net", viewModel.property.schoolNet.primary),
      ("Secondary School Net", viewModel.property.schoolNet.secondary),
      ("Building Age", "\(viewModel.property.buildingAge)"),
      ("Building Direction", viewModel.property.buildingDirection),
    ]
  }
}

#Preview {
  struct PropertyDetailListView_Preview: View {
    @EnvironmentObject var viewModel: PropertyViewModel
    var body: some View {
      PropertyDetailListView(
        viewModel: PropertyDetailViewModel(property: Mock.Properties[0]))
    }
  }
  return PropertyDetailListView_Preview()
    .environmentObject(PropertyViewModel())
}
