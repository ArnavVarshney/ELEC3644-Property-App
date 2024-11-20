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
                                        imageUrls: property.imageUrls,
                                        property: property
                                    )
                                    HStack {
                                        Text(property.name).bold()
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(property.netPrice)")
                                        Spacer()
                                    }
                                }.foregroundStyle(.black)
                            }
                        }
                    }
                    // Textual data
                }.padding()

                Divider()

                TableSection(
                    titles: [
                        "Price",
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
                        "Saleable Area",
                        "Age",
                        "Characteristics",
                    ],
                    values: [
                        properties.map { "\($0.district)" },
                        properties.map { $0.schoolNet }.map {
                            "Primary School: \($0.primary)\nSecondary School: \($0.secondary)"
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

    var body: some View {
        //I've no idea why this worked
        HStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text(title)
                    Spacer()
                }
                Spacer()
            }.background(Color(UIColor.lightGray).opacity(0.3))

            ForEach(values, id: \.self) {
                value in

                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text(value)
                        Spacer()
                    }
                    Spacer()
                }.background(getColour(cellValue: value, values: values))
            }
        }
    }

    func getColour(cellValue: String, values: [String]) -> Color {
        if let cV = Double(cellValue) {
            let valuesInt = values.map { Double($0)! }
            if cV < valuesInt.max()! {
                return Color.red
            }
        }

        return Color.clear
    }
}

struct TableSection: View {
    @State var reveal: Bool = false
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
                    Divider().frame(minHeight: 1).background(.black)

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
