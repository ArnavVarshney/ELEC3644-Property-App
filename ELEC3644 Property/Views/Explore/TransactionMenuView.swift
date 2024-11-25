//
//  TransactionMenuView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 23/11/2024.
//

import SwiftUI

struct TransactionMenuView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel

    var properties: [Property]
    var transactions: [PropertyTransaction] = []

    init(properties: [Property]) {
        self.properties = properties
        self.transactions = properties.getTransactions()
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(transactions.count)")
                    .fontWeight(.bold)
                    .font(.subheadline)
                Text(" transactions found")
                    .font(.subheadline)
            }
            Divider()
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(transactions, id: \.transaction.id) { propertyTransaction in
                        NavigationLink(
                            destination: TransactionDetailedView(
                                propertyTransaction: propertyTransaction)
                        ) {
                            TransactionRowView(propertyTransaction: propertyTransaction)
                        }
                        Divider()
                    }
                }
            }
            .refreshable {
                viewModel.initTask()
            }
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    struct TransactionMenuView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            TransactionMenuView(properties: viewModel.properties)
                .environmentObject(UserViewModel())
        }
    }
    return TransactionMenuView_Preview()
        .environmentObject(PropertyViewModel())
}

struct TransactionRowView: View {
    let propertyTransaction: PropertyTransaction

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(propertyTransaction.property.name)・\(propertyTransaction.property.address)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            HStack(alignment: .center) {
                Text(
                    "S.A. \(propertyTransaction.property.saleableArea)sqft @ \(propertyTransaction.pricePerSqft.toCompactCurrencyFormat())/sqft"
                )
                .font(.subheadline)
                .foregroundColor(.neutral60)
                Spacer()
                Text(
                    "\(propertyTransaction.transaction.date.formatted(.dateTime.year().month().day()))"
                )
                .font(.subheadline)
                .foregroundColor(.neutral100)
            }.padding(.bottom, 4)
            HStack {
                HStack {
                    Image(
                        systemName: propertyTransaction.priceDelta > 0 ? "arrow.up" : "arrow.down"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 8)
                    Text(abs(propertyTransaction.priceDelta).toCompactCurrencyFormat())
                }
                .font(.subheadline)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(propertyTransaction.priceDelta > 0 ? .green : .red)
                .cornerRadius(4)
                .foregroundColor(.neutral10)
                Text(propertyTransaction.property.contractType)
                    .font(.subheadline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(.neutral100)
                    .cornerRadius(4)
                    .foregroundColor(.neutral10)
            }
        }
        .padding(.vertical)
    }
}
