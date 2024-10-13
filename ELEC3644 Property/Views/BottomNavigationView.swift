//
//  BottomNavigationView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 13/10/2024.
//

import SwiftUI

struct BottomNavigationView: View {
    @Binding var selectedNavigation: BottomNavigation

    var body: some View {
        HStack(spacing: 48) {
            ForEach(BottomNavigation.allCases, id: \.self) { nav in
                Image(systemName: "\(nav.systemImage)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        selectedNavigation = nav
                    }
                    .foregroundColor(nav == selectedNavigation ? .primary60 : .neutral50)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .background(.neutral10)
    }
}

#Preview {
    struct MenuItemList_Preview: View {
        @State private var selected: BottomNavigation? = BottomNavigation.explore

        var body: some View {
            BottomNavigationView(selectedNavigation: .constant(.explore))
        }
    }

    return MenuItemList_Preview()
}
