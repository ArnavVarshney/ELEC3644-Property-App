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
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search listings", text: $searchText)
                }
                .padding()
                .background(Color(.neutral20))
                .cornerRadius(10)

                Divider()
                    .padding(.vertical, 8)

                if filteredProperties.isEmpty || properties.isEmpty {
                    Spacer()

                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .padding()
                    Text("No listings found")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(4)
                    Text(
                        properties.isEmpty
                            ? "You haven't created any listings"
                            : "Try searching for something else"
                    )
                    .font(.footnote)
                    .foregroundColor(.neutral70)
                    .padding(4)

                    Spacer()
                } else {
                    ListingListView(properties: filteredProperties)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Your Listings")
            .refreshable {
                propertyViewModel.initTask()
                agentViewModel.initTask()
            }
            .sheet(isPresented: $showListingModal) {
                PropertyListingForm()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showListingModal = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
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
