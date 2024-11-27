//
//  WishlistItemView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//
import SwiftUI

struct WishlistItemView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    let wishlist: Wishlist
    let firstProperty: Property
    var size: CGFloat

    init(wishlist: Wishlist, size: CGFloat = UIScreen.main.bounds.width / 2 - 32) {
        self.wishlist = wishlist
        self.size = size
        firstProperty = wishlist.properties[0]
    }

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: firstProperty.imageUrls[0])) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: size, height: size)
            } placeholder: {
                ProgressView()
                    .scaledToFill()
                    .frame(
                        width: size, height: size)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.neutral20, lineWidth: 4)
            )
            .padding(.bottom, 4)
            .addShadow()

            Text(wishlist.name)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.neutral100)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(wishlist.properties.count) saved")
                .foregroundColor(.neutral70)
                .fontWeight(.semibold)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    struct WishlistItemViewPreview: View {
        var body: some View {
            WishlistItemView(wishlist: Mock.Users[0].wishlists[0])
        }
    }
    return WishlistItemViewPreview()
}
