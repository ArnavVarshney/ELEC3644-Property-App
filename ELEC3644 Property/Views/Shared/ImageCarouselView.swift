//
//  ImageCarouselView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 21/10/24.
//
import SwiftUI

struct ImageCarouselView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    let property: Property
    let images: [String]
    let imageUrls: [String]
    let height: Double
    let favoritable: Bool
    let deletable: Bool
    let showCornerIcons: Bool
    let pickable: Bool
    let picked: Bool
    var cornerRadius: Double
    init(
        images: [String] = [], imageUrls: [String] = [], cornerRadius: Double = 8,
        height: Double = 320,
        property: Property? = nil,
        favoritable: Bool = false,
        showCornerIcons: Bool = true,
        deletable: Bool = false,
        pickable: Bool = false,
        picked: Bool = false
    ) {
        self.images = images
        self.imageUrls = imageUrls
        self.cornerRadius = cornerRadius
        self.height = height
        self.property = property ?? Mock.Properties[0]
        self.favoritable = favoritable
        self.showCornerIcons = showCornerIcons
        self.deletable = deletable
        self.pickable = pickable
        self.picked = picked
    }

    var body: some View {
        ZStack {
            if showCornerIcons && userViewModel.isLoggedIn() {
                if favoritable {
                    VStack {
                        HStack {
                            Spacer()
                            FavoriteIcon(property: property)
                        }
                        Spacer()
                    }.padding(5).zIndex(1)
                }

                if deletable {  //Implementation of delete is not in this view
                    VStack {
                        HStack {
                            Image(systemName: "xmark")
                                .frame(width: 6, height: 6)
                                .foregroundColor(.neutral100)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                            Spacer()
                        }
                        Spacer()
                    }.padding(5).zIndex(1)
                }

                if pickable {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark")
                                .frame(width: 6, height: 6)
                                .padding(12)
                                .foregroundStyle(picked ? .white : .neutral100)
                                .background(
                                    Circle()
                                        .fill(picked ? .neutral100 : Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                        }
                        Spacer()
                    }.padding(5).zIndex(1)
                }
            }

            TabView {
                if imageUrls.isEmpty {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFill()
                    }
                } else {
                    ForEach(imageUrls, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
        }.frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .tabViewStyle(.page)
    }
}

struct FavoriteIcon: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showingSheet = false
    let property: Property
    var favoritable: Bool = false
    var propertyIdx: (Int, Int)? {
        for (i, wishlist) in userViewModel.user.wishlists.enumerated() {
            for (j, property) in wishlist.properties.enumerated() {
                if property.id == self.property.id {
                    return (i, j)
                }
            }
        }
        return nil
    }

    var body: some View {
        Button {
            if propertyIdx != nil {
                // Update db
                Task {
                    await userViewModel.postWishlist(
                        property: property,
                        folderName: userViewModel.user.wishlists[propertyIdx!.0].name, delete: true
                    )
                    await userViewModel.fetchWishlist()
                }
            } else {
                showingSheet = true
            }
        } label: {
            Image(systemName: propertyIdx != nil ? "heart.fill" : "heart")
                .frame(width: 6, height: 6)
                .foregroundColor(propertyIdx != nil ? .red : .neutral100)
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.white)
                )
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)

        }
        .padding(3)
        .sheet(isPresented: $showingSheet) {
            if !userViewModel.user.wishlists.isEmpty {
                FavoriteSubmitForm(showPrevSheet: $showingSheet, property: property)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            } else {
                CreateWishlistForm(showSheet: $showingSheet, property: property)
                    .presentationDetents([.height(250)])
            }
        }
    }
}

#Preview {
    ImageCarouselView(
        imageUrls: Mock.Properties[0].imageUrls, property: Mock.Properties[0], favoritable: false,
        deletable: true, pickable: true, picked: true
    )
    .environmentObject(UserViewModel())
}
