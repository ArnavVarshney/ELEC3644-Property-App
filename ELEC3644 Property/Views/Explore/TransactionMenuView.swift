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
                Text("transactions found")
                    .font(.subheadline)
            }
            Divider()
            ScrollView(showsIndicators: false) {
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
            .refreshable {
                viewModel.initTask()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
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
            Text("\(propertyTransaction.property.name)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            Text("\(propertyTransaction.property.address)")
                .font(.subheadline)
                .fontWeight(.medium)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(
                        "S.A. \(propertyTransaction.property.saleableArea)sqft @ \(propertyTransaction.pricePerSqft.toCompactCurrencyFormat())/sqft"
                    )
                    .font(.subheadline)
                    .foregroundColor(.neutral70)

                    Text(
                        "G.F.A. \(propertyTransaction.property.grossFloorArea)sqft @ \(propertyTransaction.pricePerGrossArea.toCompactCurrencyFormat())/sqft"
                    )
                    .font(.subheadline)
                    .foregroundColor(.neutral70)

                    Text(propertyTransaction.property.contractType)
                        .font(.subheadline)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.neutral100)
                        .cornerRadius(4)
                        .foregroundColor(.neutral10)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("\(propertyTransaction.transaction.price.toCompactCurrencyFormat())")
                        .font(.title3)
                        .fontWeight(.medium)

                    Text(
                        "\(propertyTransaction.transaction.date.formatted(.dateTime.year().month().day()))"
                    )
                    .font(.subheadline)
                    .foregroundColor(.neutral100)
                }
            }
        }
        .padding(.vertical)
    }
}

struct CompactTransactionRowView: View {
    let propertyTransaction: PropertyTransaction

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(propertyTransaction.property.name)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)

                Spacer()

                Text("\(propertyTransaction.transaction.price.toCompactCurrencyFormat())")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.bottom, 4)
            Text("Contract type: \(propertyTransaction.property.contractType)")
                .font(.caption)
                .foregroundColor(.neutral70)
            Text(
                "Posting date: \(propertyTransaction.transaction.date.formatted(.dateTime.year().month().day()))"
            )
            .font(.caption)
            .foregroundColor(.neutral70)
        }
    }
}
