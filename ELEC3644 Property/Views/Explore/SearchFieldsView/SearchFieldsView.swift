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
                        .presentationDetents([.height(740)])
                case .estate:
                    EstateSearchFieldsView()
                        .presentationDetents([.height(560)])
                case .agents:
                    AgentSearchFieldsView()
                        .presentationDetents([.height(560)])
                case .transaction:
                    TransactionSearchFieldsView()
                        .presentationDetents([.height(200)])
                case .map:
                    MapSearchFieldView()
                        .presentationDetents(
                            [.height(560)])
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
