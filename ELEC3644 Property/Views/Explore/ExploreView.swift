//
//  ExploreView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText: String = ""
    @State private var currentMenu: MenuItem? = MenuItem.buy
    @EnvironmentObject private var propertyViewModel: PropertyViewModel

    var body: some View {
        VStack {
            VStack {
                SearchBarView(searchText: $searchText)
                MenuItemListView(selectedMenu: $currentMenu)
            }
            .background(.neutral10)
            .shadow(color: .neutral20, radius: 2, x: 0, y: 4)
            .padding(.bottom, 12)

            GeometryReader {
                let size = $0.size

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        PropertyCardListView(properties: propertyViewModel.properties)
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
                .scrollDisabled(true)
            }
        }
    }
}

#Preview {
    ExploreView().environmentObject(PropertyViewModel())
}
