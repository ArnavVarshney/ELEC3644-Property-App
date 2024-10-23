//
//  PropertyDetailGraph.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Charts
import SwiftUI

struct PropertyDetailGraphView: View {
  @StateObject var viewModel: PropertyDetailViewModel

  var body: some View {
    VStack(alignment: .leading) {
      Text("Transaction History")
        .font(.system(size: 24, weight: .medium))
        .foregroundColor(.neutral100)

      Chart {
        ForEach(viewModel.transactions) { transaction in
          LineMark(
            x: .value("Date", transaction.date, unit: .month),
            y: .value("Price (HKD)", transaction.price)
          )
        }
      }
      .chartXAxisLabel("Month", position: .bottom, alignment: .center)
      .chartYAxisLabel("Price (HKD)", position: .leading, alignment: .center)
      .foregroundStyle(.primary60)
      .frame(height: 200)
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  struct PropertyDetailGraphView_Preview: View {
    @StateObject var propertyViewModel = PropertyViewModel()
    @StateObject var propertyDetailViewModel: PropertyDetailViewModel

    init() {
      let propertyViewModel = PropertyViewModel()
      self._propertyDetailViewModel = StateObject(
        wrappedValue: PropertyDetailViewModel(property: propertyViewModel.properties.first!))
    }

    var body: some View {
      PropertyDetailGraphView(
        viewModel: propertyDetailViewModel
      ).environmentObject(propertyViewModel)
    }
  }

  return PropertyDetailGraphView_Preview()
}
