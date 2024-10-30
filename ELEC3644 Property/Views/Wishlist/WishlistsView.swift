//
//  WishlistsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//
import SwiftUI

struct WishlistsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    private let flexibleColumn = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var user: User {
        userViewModel.user
    }

    var body: some View {
        NavigationStack {
            VStack {
                if user.wishlists.isEmpty {
                    Image(systemName: "heart")
                        .font(.largeTitle)
                        .padding()

                    Text("You don't have any wishlists")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(4)

                    Text("When you create a new wishlist, it will appear here.")
                        .font(.footnote)
                        .foregroundColor(.neutral60)
                        .padding(4)
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: flexibleColumn) {
                            ForEach(user.wishlists) { wishlist in
                                return NavigationLink(
                                    destination: WishlistDetailView(wishlist: wishlist)
                                ) {
                                    WishlistItemView(wishlist: wishlist)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Wishlists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {

                        },
                        label: {
                            Image(systemName: "square.and.pencil")
                        })
                }
            }
        }
    }
}

#Preview {
    WishlistsView()
        .environmentObject(UserViewModel(user: Mock.Users[0]))
}
