//
//  SearchBarView.swift
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
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(10)
                    .fontWeight(.semibold)

                TextField("District | MTR | School Net | Estate", text: $searchText)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            .padding(8)
            .background(.neutral10)
            .cornerRadius(48)
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 3)
            Spacer()
            Button {
                isActive.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .padding(10)
                    .foregroundColor(.black)
                    .background(.neutral10)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Color.neutral50, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal)
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
