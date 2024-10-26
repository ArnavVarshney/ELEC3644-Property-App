//
//  WishlistDetailView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//

import SwiftUI

struct WishlistDetailView: View {
  let wishlist: Wishlist

  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack {
        ForEach(wishlist.properties) { property in
          NavigationLink(destination: PropertyDetailView(property: property)) {
            WishlistItemView(wishlist: wishlist)
          }
        }
      }
    }
  }
}
