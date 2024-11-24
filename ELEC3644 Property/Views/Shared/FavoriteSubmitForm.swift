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
                Button(action: { showSheet = true }) {
                    Text("Create wishlist")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.neutral100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                }
                .background(Color.black)
                .cornerRadius(8)
                .padding(.top, 12)
            }
            .navigationTitle("Save to wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                CreateWishlistForm(showSheet: $showPrevSheet, property: property)
                    .presentationDetents([.height(250)])
            }
            .padding()
        }
    }
}

#Preview {
    FavoriteSubmitForm(showPrevSheet: .constant(true), property: Mock.Properties[0])
        .environmentObject(UserViewModel())
}
