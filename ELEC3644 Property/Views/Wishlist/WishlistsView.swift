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
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Wishlists").bold()
                            Text("A place to view what you saved").font(.footnote).foregroundColor(
                                .neutral60)
                        }
                        Image("wishlist").resizable().scaledToFit().frame(width: 250, height: 250)
                    }.padding(.horizontal)
                    List {
                        NavigationLink {
                            FoldersView()
                        } label: {
                            HStack {
                                Image(systemName: "heart")
                                VStack(alignment: .leading) {
                                    Text("Folders").bold()
                                    Text("Look at what you had in mind").font(.footnote)
                                        .foregroundColor(
                                            .neutral60)
                                }
                            }
                        }.alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        NavigationLink {
                        } label: {
                            HStack {
                                Image(systemName: "calendar.day.timeline.trailing")
                                VStack(alignment: .leading) {
                                    Text("Property Comparison").bold()
                                    Text("Compare your wishes").font(.footnote).foregroundColor(
                                        .neutral60)
                                }
                            }
                        }
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
        }.onAppear {
            Task {
                await userViewModel.fetchWishlist()
            }
        }
    }
}

#Preview {
    WishlistsView()
        .environmentObject(UserViewModel(user: Mock.Users[0]))
}
