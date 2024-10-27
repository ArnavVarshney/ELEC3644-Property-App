//
//  WishlistDetailView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//

import SwiftUI

struct WishlistDetailView: View {
  let wishlist: Wishlist
    @State var pickedPropertiesIdx: [Int] = []
    @State var showingSheet = false

  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack {
          ForEach(wishlist.properties.indices, id: \.self) { idx in
              Button {
                  if pickedPropertiesIdx.contains(idx){
                      pickedPropertiesIdx.removeAll(where: {$0 == idx})
                  }else{
                      pickedPropertiesIdx.append(idx)
                      if pickedPropertiesIdx.count == 2{
                          showingSheet = true
                      }
                  }
              } label: {
                  if pickedPropertiesIdx.contains(idx) {
                      WishlistItemView(wishlist: wishlist).border(.blue,width: 3)
                  }else{
                      WishlistItemView(wishlist: wishlist)
                  }
              }.sheet(isPresented: $showingSheet) {
                  pickedPropertiesIdx.removeLast()
              } content: {
                  WishlistPropertyComparisonView(property1: wishlist.properties[pickedPropertiesIdx[0]], property2: wishlist.properties[pickedPropertiesIdx[1]])
              }


        }
      }
    }
  }
}


#Preview {
    WishlistDetailView(wishlist: Mock.Users[0].wishlists[0]).environmentObject(UserViewModel())
}
