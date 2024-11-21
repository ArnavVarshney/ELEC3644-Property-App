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
                    WishlistsList(items: [
                        SettingsItem(
                            destination: AnyView(FoldersView()), iconName: "heart",
                            title: "Folders", subtitle: "Look at what you had in mind"),
                        SettingsItem(
                            destination: AnyView(FoldersView()),
                            iconName: "calendar.day.timeline.trailing",
                            title: "Property Comparison", subtitle: "Compare your wishes"),
                    ])
                    Spacer()
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
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "square.and.pencil")
                        }
                    )
                }
            }
        }.onAppear {
            Task {
                await userViewModel.fetchWishlist()
            }
        }
    }
}

struct WishlistsList: View {
    let items: [SettingsItem]

    var body: some View {
        LazyVStack {
            ForEach(0..<items.count, id: \.self) { index in
                NavigationLink(destination: items[index].destination) {
                    HStack(spacing: 15) {
                        Image(systemName: items[index].iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(LocalizedStringKey(items[index].title))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Text(LocalizedStringKey(items[index].subtitle))
                                .font(.footnote)
                                .foregroundColor(.neutral70)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 12, height: 12)
                    }
                    .padding(.vertical, 3)
                }
                if index < items.count - 1 {
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WishlistsView()
        .environmentObject(UserViewModel(user: Mock.Users[0]))
}
