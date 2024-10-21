//
//  SearchBar.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isActive: Bool

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(10)

                TextField(text: $searchText) {
                    Text("District | MTR | School Net | University | Estate")
                        .font(.subheadline)
                }
            }
            Spacer()
            Button {
                isActive.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
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
        .padding(.horizontal, 24)
        .shadow(color: .neutral20, radius: 4, x: 0, y: 4)
    }
}

#Preview {
    struct SearchBar_Preview: View {
        @State private var searchText = ""

        var body: some View {
            SearchBarView(searchText: $searchText, isActive: .constant(true))
        }
    }

    return SearchBar_Preview()
}
