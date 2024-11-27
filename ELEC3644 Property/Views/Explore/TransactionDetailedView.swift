//
//  TransactionDetailedView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 23/11/2024.
//

import SwiftUI

struct TransactionDetailedView: View {
    @EnvironmentObject private var viewModel: PropertyViewModel
    var propertyTransaction: PropertyTransaction

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ImageCarouselView(
                        imageUrls: propertyTransaction.property.imageUrls, cornerRadius: 0,
                        property: propertyTransaction.property
                    )
                    VStack {
                        VStack(alignment: .leading) {
                            Text(propertyTransaction.property.name)
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.neutral100)
                                .lineLimit(1)
                            Text(propertyTransaction.property.address)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.neutral100)
                            HStack(spacing: 0) {
                                Text(LocalizedStringKey(propertyTransaction.property.district))
                                Text(", ")
                                Text(LocalizedStringKey(propertyTransaction.property.area))
                            }
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.neutral70)
                        }
                        HStack(alignment: .center) {
                            Text(propertyTransaction.transaction.price.toCompactCurrencyFormat())
                                .font(.subheadline)
                                .foregroundColor(.neutral100)
                            Text(
                                "on \(propertyTransaction.transaction.date.formatted(.dateTime.month().day().year()))"
                            )
                            .font(.subheadline)
                            .foregroundColor(.neutral70)
                            Spacer()
                            Text(propertyTransaction.property.contractType)
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(.neutral100)
                                .cornerRadius(4)
                                .foregroundColor(.neutral10)
                        }
                        Divider()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Price Delta")
                                    .font(.subheadline)
                                    .foregroundColor(.neutral70)
                                Text(propertyTransaction.priceDelta.toCompactCurrencyFormat())
                                    .font(.subheadline)
                                    .foregroundColor(.neutral100)
                            }

                            Spacer()

                            VStack(alignment: .leading) {
                                Text("Price/Sqft")
                                    .font(.subheadline)
                                    .foregroundColor(.neutral70)
                                Text(propertyTransaction.pricePerSqft.toCompactCurrencyFormat())
                                    .font(.subheadline)
                                    .foregroundColor(.neutral100)
                            }

                            Spacer()

                            VStack(alignment: .leading) {
                                Text("Saleable Area")
                                    .font(.subheadline)
                                    .foregroundColor(.neutral70)
                                Text("\(propertyTransaction.property.saleableArea) sqft")
                                    .font(.subheadline)
                                    .foregroundColor(.neutral100)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Transaction History")
                                .font(.subheadline)
                                .foregroundColor(.neutral100)
                                .padding(.top, 16)
                            Divider()
                            ForEach(propertyTransaction.property.getTransactions(), id: \.id) {
                                transaction in
                                TransactionRow(propertyTransaction: transaction)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                }
            }
            .padding(.bottom, 64)
            .backButton()
            .ignoresSafeArea(edges: [.top, .horizontal])
            ViewPropertyButtonView(property: propertyTransaction.property)
        }
    }
}

#Preview {
    struct TransactionDetailedView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel

        var mockPropertyTransaction: PropertyTransaction {
            .init(
                transaction: Mock.Properties.first!.transactionHistory.first!,
                property: Mock.Properties.first!, priceDelta: 1000)
        }

        var body: some View {
            TransactionDetailedView(propertyTransaction: mockPropertyTransaction)
                .environmentObject(UserViewModel())
        }
    }
    return TransactionDetailedView_Preview()
        .environmentObject(PropertyViewModel())
}

struct TransactionRow: View {
    let propertyTransaction: PropertyTransaction

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
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
                Spacer()

                Text(
                    propertyTransaction.transaction.date.formatted(.dateTime.month().day().year())
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
                .padding(.trailing, 24)

                VStack(alignment: .leading) {
                    Text(propertyTransaction.transaction.price.toCompactCurrencyFormat()).font(
                        .headline)

                    Text(
                        (propertyTransaction.transaction.price
                            / propertyTransaction.property.saleableArea)
                            .toCompactCurrencyFormat() + "/sqft"
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct ViewPropertyButtonView: View {
    var property: Property

    var body: some View {
        VStack {
            Spacer()
            NavigationLink {
                PropertyDetailView(property: property)
            } label: {
                Text("View Property")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .addShadow()
                    .background(.neutral100)
                    .cornerRadius(36)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}
