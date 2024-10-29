//
//  SearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//

import SwiftUI

struct SearchFieldsView: View {
    let currentMenu: MenuItem?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                switch currentMenu {
                case .buy, .rent:
                    PropertySearchFieldsView()
                case .estate:
                    EstateSearchFieldsView()
                case .agents:
                    AgentSearchFieldsView()
                default:
                    EmptyView()
                }
                Spacer()
            }
            .padding()
            .background(Color.neutral10)
            .navigationBarItems(
                leading: Button(
                    "Cancel",
                    action: {
                        dismiss()
                    }
                ).foregroundColor(.primary60),
                trailing: Button("Done", action: {}).foregroundColor(.primary60)
            )
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
