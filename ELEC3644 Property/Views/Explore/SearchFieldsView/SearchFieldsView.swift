//
//  SearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct SearchFieldsView: View {
    let currentMenu: MenuItem?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                switch currentMenu {
                case .buy, .rent, .lease:
                    PropertySearchFieldsView()
                case .estate:
                    EstateSearchFieldsView()
                case .agents:
                    AgentSearchFieldsView()
                default:
                    EmptyView()
                }
            }
            .padding(.all, 16)
            .background(Color.neutral10)
            .navigationTitle(currentMenu?.rawValue ?? "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

#Preview {
    struct SearchFieldsView_Preview: View {
        @State private var searchText = ""
        var body: some View {
            SearchFieldsView(currentMenu: .buy)
        }
    }
    return SearchFieldsView_Preview()
}
