//
//  MenuItemList.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct MenuItemListView: View {
    let menuItems: [MenuItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(menuItems, id: \.self) { item in
                    MenuItemView(item: item)
                }
            }
        }
    }
}

#Preview {
    struct MenuItemList_Preview: View {
        private var menuItems = [
            MenuItem(title: "test1", icon: "house"),
            MenuItem(title: "test2", icon: "house"),
            MenuItem(title: "test3", icon: "house"),
            MenuItem(title: "test4", icon: "house"),
        ]

        var body: some View {
            MenuItemListView(menuItems: menuItems)
                .padding()
        }
    }

    return MenuItemList_Preview()
}
