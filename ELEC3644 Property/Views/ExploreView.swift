//
//  ExploreView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

var properties: [Property] = [
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
    @State private var currentMenu: MenuItem? = MenuItem.buy

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    SearchBarView(searchText: $searchText)
                    MenuItemListView(selectedMenu: $currentMenu)
                }
                .background(.neutral10)
                .shadow(color: .neutral20, radius: 4, x: 0, y: 4)
                .padding(.bottom, 12)

                GeometryReader {
                    let size = $0.size

                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            PropertyCardListView(properties: properties)
                                .id(MenuItem.buy)
                                .frame(width: size.width)
                            ForEach(MenuItem.allCases.dropFirst(), id: \.self) { menuItem in
                                Text(menuItem.rawValue)
                                    .id(menuItem.rawValue)
                                    .frame(width: size.width, height: size.height)
                            }
                        }
                    }
                    .scrollPosition(id: $currentMenu)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                }
            }
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbarVisibility(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    ExploreView()
}
