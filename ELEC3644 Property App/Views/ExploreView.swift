//
//  ExploreView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

private var menuItems = [
    MenuItem(title: "Buy", icon: "house"),
    MenuItem(title: "Rent", icon: "house.fill"),
    MenuItem(title: "Lease", icon: "text.document.fill"),
    MenuItem(title: "Transaction", icon: "chart.line.uptrend.xyaxis"),
    MenuItem(title: "Estate", icon: "building"),
    MenuItem(title: "Agents", icon: "person.crop.circle"),
]

private var properties: [Property] = [
    Property(name: "Grandview Garden - 1E",
             address: "8 Nam Long Shan Road",
             area: "HK Island",
             district: "Central and Western",
             subDistrict: "Sheung Wan",
             facilities: [
                 Facility(desc: "mtr", measure: 8, measureUnit: "min(s)"),
             ],
             schoolNet: SchoolNet(
                 primary: "11",
                 secondary: "Central and Western District"
             ),
             saleableArea: 305,
             saleableAreaPricePerSquareFoot: 14262,
             grossFloorArea: 417,
             grossFloorAreaPricePerSquareFoot: 10432,
             netPrice: "7.4m",
             buildingAge: 39,
             buildingDirection: "South East",
             estate: "Grandview Garden"),
    Property(name: "Grandview Garden - 1E",
             address: "8 Nam Long Shan Road",
             area: "HK Island",
             district: "Central and Western",
             subDistrict: "Sheung Wan",
             facilities: [
                 Facility(desc: "mtr", measure: 8, measureUnit: "min(s)"),
             ],
             schoolNet: SchoolNet(
                 primary: "11",
                 secondary: "Central and Western District"
             ),
             saleableArea: 305,
             saleableAreaPricePerSquareFoot: 14262,
             grossFloorArea: 417,
             grossFloorAreaPricePerSquareFoot: 10432,
             netPrice: "7.4m",
             buildingAge: 39,
             buildingDirection: "South East",
             estate: "Grandview Garden"),
    Property(name: "Grandview Garden - 1E",
             address: "8 Nam Long Shan Road",
             area: "HK Island",
             district: "Central and Western",
             subDistrict: "Sheung Wan",
             facilities: [
                 Facility(desc: "mtr", measure: 8, measureUnit: "min(s)"),
             ],
             schoolNet: SchoolNet(
                 primary: "11",
                 secondary: "Central and Western District"
             ),
             saleableArea: 305,
             saleableAreaPricePerSquareFoot: 14262,
             grossFloorArea: 417,
             grossFloorAreaPricePerSquareFoot: 10432,
             netPrice: "7.4m",
             buildingAge: 39,
             buildingDirection: "South East",
             estate: "Grandview Garden"),
]

struct ExploreView: View {
    @State private var searchText: String = ""
    @State private var tags: [Tag] = [
        Tag(label: "Location"),
        Tag(label: "Price"),
        Tag(label: "SchoolNet"),
        Tag(label: "Room"),
        Tag(label: "University"),
        Tag(label: "More"),
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText)
                Divider()

                MenuItemListView(menuItems: menuItems)
                Divider()

                TagListView(tags: $tags)
                Divider()

                PropertyCardListView(properties: properties)
                Spacer()
            }.padding(.horizontal, 24)
        }
    }
}

#Preview {
    ExploreView()
}
