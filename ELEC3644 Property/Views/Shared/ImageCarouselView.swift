//
//  ImageCarouselView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 21/10/24.
//

import SwiftUI

struct ImageCarouselView: View {
    let property: Property
    let images: [String]
    let imageUrls: [String]
    let height: Double
    let favoritable: Bool
    var cornerRadius: Double

    init(
        images: [String] = [], imageUrls: [String] = [], cornerRadius: Double = 8,
        height: Double = 320,
        property: Property? = nil,
        favoritable: Bool = false
    ) {
        self.images = images
        self.imageUrls = imageUrls
        self.cornerRadius = cornerRadius
        self.height = height
        self.property = property ?? Mock.Properties[0]
        self.favoritable = favoritable
    }

    var body: some View {
        ZStack {
            if favoritable {
                VStack {
                    HStack {
                        Spacer()
                        favoriteIcon(property: property)
                    }
                    Spacer()
                }.padding(5).zIndex(1)
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

struct favoriteIcon: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showingSheet = false

    let property: Property
    var propertyIdx: (Int, Int)? {
        for (i, wishlist) in userViewModel.user.wishlists.enumerated() {
            for (j, property) in wishlist.properties.enumerated() {
                if property.dbId == self.property.dbId {
                    return (i, j)
                }
            }
        }
        return nil
    }

    var body: some View {
        Button {
            if propertyIdx != nil {
                //Update db
                    Task{
                        await userViewModel.postWishlist(property: property, folderName: userViewModel.user.wishlists[propertyIdx!.0].name, delete: true)
                        await userViewModel.fetchWishlist(with: userViewModel.currentUserId)
                    }
//                    //We're going to unfavorite
//                    userViewModel.user.wishlists[propertyIdx!.0].properties.remove(
//                        at: propertyIdx!.1)
//
//                    //Check for empty folder
//                    userViewModel.user.wishlists = userViewModel.user.wishlists.filter({
//                        !$0.properties.isEmpty
//                    })
            } else {
                showingSheet = true
            }
        } label: {
            Image(systemName: propertyIdx != nil ? "heart.fill" : "heart")
                .frame(width: 6, height: 6)
                .foregroundColor(propertyIdx != nil ? .red : .black)
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.white)
                )
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
        }
        .padding(3)
        .sheet(isPresented: $showingSheet) {
            FavoriteSubmitForm(property: property).presentationDetents([.height(250.0)])
        }
    }
}

#Preview {
    ImageCarouselView(
        imageUrls: Mock.Properties[0].imageUrls, property: Mock.Properties[0], favoritable: true
    )
    .environmentObject(UserViewModel())
}
