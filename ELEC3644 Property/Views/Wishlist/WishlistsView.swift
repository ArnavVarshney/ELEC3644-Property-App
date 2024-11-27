//
//  WishlistsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//
import SwiftUI

struct WishlistsView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if userViewModel.isLoggedIn() {
                    if userViewModel.user.wishlists.isEmpty {
                        VStack {
                            Image(systemName: "heart")
                                .font(.largeTitle)
                                .padding()

                            Text("You don't have any wishlists")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .padding(4)

                            Text("When you create a new wishlist, it will appear here.")
                                .font(.footnote)
                                .foregroundColor(.neutral70)
                                .padding(4)
                        }
                    } else {
                        WishlistGrid()
                            .padding(.top, 16)
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("Log in to view your wishlists")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)
                        Text("You can create, view, or edit wishlists once you've logged in.")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                            .padding(.trailing, 8)
                        LoginButton()
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Wishlists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HistoryView()) {
                        Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    }
                }
            }
        }.onAppear {
            Task {
                await userViewModel.fetchWishlist()
            }
        }
    }
}

struct WishlistGrid: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<userViewModel.user.wishlists.count, id: \.self) { index in
                    if index % 2 == 0 {
                        HStack(spacing: 32) {
                            NavigationLink(
                                destination: WishlistDetailView(
                                    wishlistId: userViewModel.user.wishlists[index].id
                                ) { removedProperties in
                                    for property in removedProperties {
                                        Task {
                                            await userViewModel.postWishlist(
                                                property: property,
                                                folderName: userViewModel.user.wishlists[index]
                                                    .name, delete: true)
                                        }
                                    }
                                    Task {
                                        await userViewModel.fetchWishlist()
                                    }
                                }
                            ) {
                                WishlistItemView(
                                    wishlist: userViewModel.user.wishlists[index],
                                    size: UIScreen.main.bounds.width / 2 - 32)
                            }
                            if index + 1 < userViewModel.user.wishlists.count {
                                NavigationLink(
                                    destination: WishlistDetailView(
                                        wishlistId: userViewModel.user.wishlists[index + 1].id
                                    ) { removedProperties in
                                        for property in removedProperties {
                                            Task {
                                                await userViewModel.postWishlist(
                                                    property: property,
                                                    folderName: userViewModel.user.wishlists[
                                                        index + 1
                                                    ].name, delete: true)
                                            }
                                        }
                                        Task {
                                            await userViewModel.fetchWishlist()
                                        }
                                    }
                                ) {
                                    WishlistItemView(
                                        wishlist: userViewModel.user.wishlists[index + 1],
                                        size: UIScreen.main.bounds.width / 2 - 32)
                                }
                            } else {
                                WishlistItemView(
                                    wishlist: userViewModel.user.wishlists[index],
                                    size: UIScreen.main.bounds.width / 2 - 32
                                )
                                .hidden()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }

}

#Preview {
    WishlistsView()
        .environmentObject(UserViewModel(user: Mock.Users[0]))
}
