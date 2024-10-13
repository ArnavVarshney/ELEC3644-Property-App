//
//  SearchBar.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .padding(10)
            VStack(alignment: .leading, spacing: 0) {
                Text("Where to?")
                    .font(.system(size: 14, weight: .medium))
                Text("Anywhere · Any week · Any guests")
                    .font(.system(size: 12, weight: .medium))
            }
            Spacer()
            Button {} label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .padding(10)
                    .foregroundColor(.neutral100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1000).inset(by: 1)
                            .strokeBorder(.neutral40, lineWidth: 1)
                    )
            }
        }
        .padding(12)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(.neutral40, lineWidth: 1)
        )
        .shadow(color: .neutral40, radius: 8)
        .padding(.horizontal, 24)
    }
}

#Preview {
    struct SearchBar_Preview: View {
        @State private var searchText = ""

        var body: some View {
            SearchBarView(searchText: $searchText)
        }
    }

    return SearchBar_Preview()
}
