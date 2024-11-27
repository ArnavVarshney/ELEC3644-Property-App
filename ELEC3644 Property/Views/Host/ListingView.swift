//
//  ListingView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//
import SwiftUI

struct ListingView: View {
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    @EnvironmentObject private var agentViewModel: AgentViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var showListingModal: Bool = false
    @State private var searchText: String = ""

    func queryString(properties: [Property], query: String) -> [Property] {
        return properties.filter({ property in
            return query.isEmpty ? true : property.name.contains(query)
        })
    }

    var body: some View {
        let properties = propertyViewModel.getByAgent(agentId: userViewModel.currentUserId())
        let filteredProperties = queryString(properties: properties, query: searchText)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button(action: {
                        showListingModal = true
                    }) {
                        Label("Create a new listing", systemImage: "plus")
                            .foregroundStyle(.neutral70)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.neutral40, lineWidth: 1)
                            )
                            .addShadow()
                    }
                    .padding(.vertical, 12)

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search listings & transactions", text: $searchText)
                    }
                    .padding()
                    .background(Color(.neutral20))
                    .cornerRadius(10)
                    .padding(.bottom, 12)
                    Divider()
                    Text("Your listings")
                        .font(.title)
                        .fontWeight(.bold)

                    if filteredProperties.isEmpty {
                        Text("No listings found")
                            .foregroundColor(.neutral70)
                            .padding(.top, 12)
                    } else {
                        LazyVStack {
                            ForEach(filteredProperties) { property in
                                PropertyRowView(property: property)
                                    .padding(.vertical, 4)
                            }
                        }
                    }

                    Divider()
                    Text("Recent transactions")
                        .font(.title)
                        .fontWeight(.bold)
                    if filteredProperties.isEmpty {
                        Text("No transactions found")
                            .foregroundColor(.neutral70)
                            .padding(.top, 12)
                    } else {
                        LazyVStack {
                            ForEach(filteredProperties.getTransactions()) { propertyTransactions in
                                CompactTransactionRowView(propertyTransaction: propertyTransactions)
                                    .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Welcome Back, \(userViewModel.user.name)")
            .sheet(isPresented: $showListingModal) {
                PropertyListingForm()
            }
            .refreshable {
                propertyViewModel.initTask()
                agentViewModel.initTask()
            }
        }
    }
}

#Preview {
    ListingView()
        .environmentObject(PropertyViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
