//
//  WishlistsItemView.swift
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
    self.firstProperty = wishlist.properties[0]
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AsyncImage(url: URL(string: firstProperty.imageUrls[1])) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        ProgressView()
      }
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(.neutral20, lineWidth: 4)
      )
      .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
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
