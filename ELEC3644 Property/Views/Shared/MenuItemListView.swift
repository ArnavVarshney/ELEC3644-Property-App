//
//  MenuItemListView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

enum MenuItem: String, CaseIterable {
    case buy = "Buy"
    case rent = "Rent"
    case lease = "Lease"
    case transaction = "Transaction"
    case agents = "Agents"
    case map = "Map"
    var systemImage: String {
        switch self {
        case .buy:
            return "house"
        case .rent:
            return "house.fill"
        case .lease:
            return "text.document.fill"
        case .transaction:
            return "chart.line.uptrend.xyaxis"
        case .agents:
            return "person.crop.circle"
        case .map:
            return "map"
        }
    }
}

struct MenuItemListView: View {
    @Binding var selectedMenu: MenuItem?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MenuItem.allCases, id: \.self) { item in
                    if item == selectedMenu {
                        MenuItemView(item: item)
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.neutral100),
                                alignment: .bottom
                            )
                    } else {
                        MenuItemView(item: item)
                            .onTapGesture {
                                withAnimation(.snappy) { selectedMenu = item }
                            }
                            .foregroundColor(.neutral70)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    struct MenuItemList_Preview: View {
        @State private var selected: MenuItem? = MenuItem.buy
        var body: some View {
            MenuItemListView(selectedMenu: $selected)
                .padding()
        }
    }
    return MenuItemList_Preview()
}
