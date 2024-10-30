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
            .chartYAxis {
                AxisMarks(position: .leading) {
                    let value = $0.as(Int.self)!
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        Text("\(formatPoints(from: value))")
                    }
                }
            }
            .chartYScale(domain: .automatic(includesZero: false))
            .foregroundStyle(.primary60)
            .frame(height: 200)
        }
        .padding(.horizontal, 24)
    }
            
    func formatPoints(from: Int) -> String {
        let number = Double(from)
        let billion = number / 1_000_000_000
        let million = number / 1_000_000
        let thousand = number / 1000
        
        if billion >= 1.0 {
            return "\(round(billion * 10) / 10)B"
        } else if million >= 1.0 {
            return "\(round(million * 10) / 10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand * 10) / 10)K"
        } else {
            return "\(Int(number))"
        }
    }
            
}

#Preview {
    struct PropertyDetailGraphView_Preview: View {
        @StateObject var propertyViewModel = PropertyViewModel()
        @StateObject var propertyDetailViewModel: PropertyDetailViewModel
        
        init() {
            self._propertyDetailViewModel = StateObject(
                wrappedValue: PropertyDetailViewModel(property: Mock.Properties[0]))
        }
        
        var body: some View {
            PropertyDetailGraphView(
                viewModel: propertyDetailViewModel
            ).environmentObject(propertyViewModel)
        }
    }
    
    return PropertyDetailGraphView_Preview()
}
