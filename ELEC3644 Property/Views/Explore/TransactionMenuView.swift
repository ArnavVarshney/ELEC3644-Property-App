//
//  TransactionMenuView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 23/11/2024.
//

import SwiftUI

struct TransactionMenuView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel
    @EnvironmentObject private var userViewModel: UserViewModel

    var properties: [Property]
    var transactions: [PropertyTransaction] = []

    init(properties: [Property]) {
        self.properties = properties
        self.transactions = properties.getTransactions()
    }

    var body: some View {
        let filteredTransactions = transactions.filter({ transaction in
            transaction.property.contractType == viewModel.searchFields.contractType
        })

        VStack(alignment: .leading) {
            HStack {
                Text("\(filteredTransactions.count)")
                    .fontWeight(.bold)
                    .font(.subheadline)
                Text("transaction(s) found")
                    .font(.subheadline)
            }
            Divider()
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(filteredTransactions, id: \.transaction.id) { propertyTransaction in
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
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}

#Preview {
    struct TransactionMenuView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            TransactionMenuView(properties: viewModel.properties)
        }
    }
    return TransactionMenuView_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
}

struct TransactionRowView: View {
    let propertyTransaction: PropertyTransaction
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                AsyncImageView(
                    url: URL(string: propertyTransaction.property.imageUrls[0])!,
                    context: viewContext
                )
                .frame(width: 100)

                Text(propertyTransaction.property.contractType)
                    .font(.subheadline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(.neutral100)
                    .cornerRadius(4)
                    .foregroundColor(.neutral10)
            }
            .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text("\(propertyTransaction.property.name)")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.neutral100)
                    .multilineTextAlignment(.leading)
                Text("\(propertyTransaction.property.address)")
                    .font(.footnote)
                    .fontWeight(.medium)
                Text(
                    "\(propertyTransaction.property.area), \(propertyTransaction.property.subDistrict)"
                )
                .font(.footnote)
                .fontWeight(.medium)
                Spacer()

                HStack(alignment: .bottom) {
                    HStack {
                        VStack {
                            Text(
                                "S.A. \(propertyTransaction.property.saleableArea) ft²"
                            )
                            Text(
                                "GFA \(propertyTransaction.property.grossFloorArea) ft²"
                            )
                        }
                        .font(.caption)
                        .foregroundColor(.neutral100)
                        VStack {
                            Text("@ \(propertyTransaction.pricePerSqft.toCompactCurrencyFormat())")
                            Text(
                                "@ \(propertyTransaction.pricePerGrossArea.toCompactCurrencyFormat())"
                            )
                        }
                        .font(.caption)
                        .foregroundColor(.neutral70)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(propertyTransaction.transaction.price.toCompactCurrencyFormat())")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral100)

                        Text(
                            "\(propertyTransaction.transaction.date.formatted(.dateTime.year().month().day()))"
                        )
                        .font(.caption)
                        .foregroundColor(.neutral70)
                    }

                }
            }
        }
        .padding(.vertical, 6)
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
