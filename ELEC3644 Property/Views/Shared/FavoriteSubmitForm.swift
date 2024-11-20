//
//  FavoriteSubmitForm.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 27/10/2024.
//
import SwiftUI

struct FavoriteSubmitForm: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss

    @State var albumName: String = ""
    @State var showSheet = false
    @Binding var showPrevSheet: Bool

    let property: Property
    private let flexibleColumn = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: flexibleColumn) {
                                ForEach(userViewModel.user.wishlists.indices, id: \.self) { idx in
                                    Button {
                                        let temp = userViewModel.user.wishlists[idx].name
                                        Task {
                                            await userViewModel.postWishlist(
                                                property: property, folderName: temp)
                                            await userViewModel.fetchWishlist()
                                        }
                                        withAnimation {
                                            dismiss()
                                        }
                                    } label: {
                                        WishlistItemView(
                                            wishlist: userViewModel.user.wishlists[idx])
                                    }
                                }
                            }
                        }
                    }

                }

                Button {
                    showSheet = true
                } label: {
                    Text("Create wishlist").padding(
                        .init(top: 0, leading: 100, bottom: 0, trailing: 100))
                }.padding(10)
                    .background(Rectangle().fill(.black))
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 5))
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }.foregroundStyle(.black)
                }

                ToolbarItem(placement: .principal) {
                    Text("Save to wishlist")
                }
            }
            .sheet(isPresented: $showSheet) {
                CreateWishlistForm(showSheet: $showPrevSheet, property: property)
                    .presentationDetents([.height(350)])
            }
        }
    }
}

#Preview {
    FavoriteSubmitForm(showPrevSheet: .constant(true), property: Mock.Properties[0])
        .environmentObject(UserViewModel())
}
