//
//  PropertyDetailBottomBarView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import SwiftUI

struct PropertyDetailBottomBarView: View {
  @StateObject var viewModel: PropertyDetailViewModel

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("$\(viewModel.property.netPrice) HKD")
          .font(.system(size: 16, weight: .bold))
        Text("20 year installments")
          .font(.system(size: 14, weight: .regular))
      }
      Spacer()
      requestButton
    }
    .padding()
    .background(Color(.systemGray6))
  }

  private var requestButton: some View {
    Text("Request")
      .font(.system(size: 16, weight: .medium))
      .foregroundColor(.neutral10)
      .padding()
      .background(Color.primary60)
      .cornerRadius(10)
  }
}

#Preview {
  struct PropertyDetailBottomBar_Preview: View {
    @EnvironmentObject var viewModel: PropertyViewModel
    var body: some View {
      PropertyDetailBottomBarView(
        viewModel: PropertyDetailViewModel(property: viewModel.properties.first!))
    }
  }
  return PropertyDetailBottomBar_Preview()
    .environmentObject(PropertyViewModel())
}
