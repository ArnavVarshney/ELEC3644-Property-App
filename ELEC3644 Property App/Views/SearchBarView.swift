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
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
            TextField("What are you looking for?", text: $searchText)
                .font(.system(size: 14, weight: .medium))
            Spacer()
            Button {} label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .padding(10)
                    .foregroundColor(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1000).inset(by: 1)
                            .strokeBorder(Color.gray, lineWidth: 1)
                    )
            }
        }.padding(.horizontal, 12).padding(.vertical, 8)
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
