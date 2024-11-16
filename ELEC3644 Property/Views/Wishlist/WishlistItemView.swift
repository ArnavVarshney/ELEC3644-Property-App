//
//  WishlistItemView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//
import SwiftUI

struct WishlistItemView: View {
    let wishlist: Wishlist
    let firstProperty: Property
    init(wishlist: Wishlist) {
        self.wishlist = wishlist
        firstProperty = wishlist.properties[0]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: firstProperty.imageUrls[0])) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                let index = Int.random(in: 0..<mockPropertyImages.count)
                Image(mockPropertyImages[index])
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.neutral20, lineWidth: 4)
            )
            .addShadow()
            .padding(.bottom, 2)
            VStack(alignment: .leading) {
                Text(wishlist.name)
                    .fontWeight(.bold)
                    .foregroundColor(.neutral100)
                Text("\(wishlist.properties.count) saved")
                    .foregroundColor(.neutral60)
                    .font(.caption)
            }
        }
        .padding(.all, 4)
    }
}

#Preview {
    struct WishlistItemViewPreview: View {
        var body: some View {
            WishlistItemView(wishlist: Mock.Users[0].wishlists[0])
                .frame(width: 160, height: 200)
        }
    }
    return WishlistItemViewPreview()
}
