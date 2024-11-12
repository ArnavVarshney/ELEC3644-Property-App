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

                Divider()
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16))
                            .foregroundColor(.neutral100)
                            .padding()
                            .cornerRadius(10)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Text("Search")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.neutral10)
                            .padding()
                            .background(Color.primary60)
                            .cornerRadius(10)
                    }
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
