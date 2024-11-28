//
//  WishlistPropertyComparisonView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 27/10/2024.
//
import SwiftUI

struct WishlistPropertyComparisonView: View {
    @Environment(\.dismiss) private var dismiss
    let properties: [Property]
    let screenWidth = UIScreen.main

    @State var priceSectionRevealed: Bool = true
    @State var valuationSectionRevealed: Bool = false
    @State var unitInfoSectionRevealed: Bool = false
    @State var mortgageCalcSectionRevealed: Bool = false
    @State var estateInfoSectionRevealed: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                // Graphical data
                Grid(horizontalSpacing: 9) {
                    GridRow {
                        ForEach(properties.indices, id: \.self) {
                            idx in
                            let property = properties[idx]
                            NavigationLink {
                                PropertyDetailView(property: property)
                            } label: {
                                VStack {
                                    ImageCarouselView(
                                        imageUrls: [property.imageUrls.first!],
                                        height: 150, property: property
                                    )
                                    HStack {
                                        Text(property.name).bold().lineLimit(1)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(property.netPrice.toCompactCurrencyFormat())")
                                        Spacer()
                                    }
                                }.foregroundStyle(.neutral100)
                            }
                        }
                    }
                    // Textual data
                }.padding()

                Divider()

                TableSection(
                    titles: [
                        "Net Price",
                        "Price/ft² (S.A)",
                    ],
                    values: [
                        properties.map { "\($0.netPrice)" },
                        properties.map { "\($0.saleableAreaPricePerSquareFoot)" },
                    ],
                    section: "Price"
                )

                Divider()

                TableSection(
                    titles: [
                        "Saleable Area",
                        "Age",
                        "Characteristics",
                    ],
                    values: [
                        properties.map { "\($0.saleableArea)" },
                        properties.map { "\($0.buildingAge)" },
                        properties.map { "\($0.propertyType)" },
                    ],
                    section: "Unit Information"
                )

                Divider()

                TableSection(
                    titles: [
                        "District",
                        "School Net",
                        "Amenities",
                    ],
                    values: [
                        properties.map { "\($0.district)" },
                        properties.map { $0.schoolNet }.map {
                            "Primary: \($0.primary)\nSecondary: \($0.secondary)"
                        },
                        properties.map { $0.facilities }.map {
                            $0.map { $0.desc }.joined(separator: ",")
                        },
                    ],
                    section: "Estate Info."
                )
            }
        }
    }
}

struct TableEntry: View {
    let values: [String]
    let title: String

    var formattedValues: [String] {
        if ["Net Price", "Price/ft² (S.A)"].contains(title) {
            return values.map { value in Int(value)!.toCompactCurrencyFormat() }
        }
        return values.map { $0.capitalized }
    }

    var body: some View {
        //I've no idea why this worked
        HStack {
            Text(title)
                .frame(width: 140, alignment: .leading)
                .padding(0)
            Spacer()

            ForEach(values.indices, id: \.self) {
                idx in

                VStack {
                    Spacer()
                    Text(formattedValues[idx])
                        .foregroundColor(getColour(cellValue: values[idx]))
                    Spacer()
                }
                .frame(width: 100, alignment: .leading)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
    }

    func getColour(cellValue: String) -> Color {
        return .neutral100
    }
}

struct TableSection: View {
    @State var reveal: Bool = true
    let titles: [String]
    let values: [[String]]
    let section: String

    var body: some View {
        VStack {
            HStack {
                Text(section)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        reveal.toggle()
                    }
                } label: {
                    Image(systemName: reveal ? "chevron.down" : "chevron.right")
                }
            }.padding()
            if reveal {
                ForEach(titles.indices, id: \.self) { idx in
                    TableEntry(values: values[idx], title: titles[idx])
                }
            }
        }
    }
}

#Preview {
    WishlistPropertyComparisonView(properties: [Mock.Properties[0], Mock.Properties[1]])
        .environmentObject(UserViewModel())
}
