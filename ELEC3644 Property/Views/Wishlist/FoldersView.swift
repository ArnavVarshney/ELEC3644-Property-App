//
//  BookmarkView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 14/11/2024.
//

import SwiftUI

struct FoldersView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    private let flexibleColumn = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if userViewModel.user.wishlists.isEmpty {
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
                            ForEach(userViewModel.user.wishlists.indices, id: \.self) { idx in
                                NavigationLink(
                                    destination: WishlistDetailView(
                                        wishlist: userViewModel.user.wishlists[idx])
                                ) {
                                    WishlistItemView(wishlist: userViewModel.user.wishlists[idx])
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Folders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {

                        },
                        label: {
                            Image(systemName: "square.and.pencil")
                        })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image(systemName: "chevron.left")
                        })
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    FoldersView().environmentObject(UserViewModel())
}
