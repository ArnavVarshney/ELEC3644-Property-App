//
//  WishlistDetailView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//

import SwiftUI

struct WishlistDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let wishlist: Wishlist
    var pickedProperties: [Property] {
        var picked: [Property] = []
        for idx in pickedPropertiesIdx {
            picked.append(wishlist.properties[idx])
        }
        return picked
    }

    @State var pickedPropertiesIdx: [Int] = []
    @State var showingChoice = true

    //TODO: Try adding border on the invisible background
    var body: some View {
        NavigationStack {
            ZStack {
                if showingChoice {
                    HStack {
                        VStack(alignment: .leading, spacing: 0.3) {
                            ForEach(wishlist.properties.indices, id: \.self) { idx in
                                Button{
                                    if pickedPropertiesIdx.contains(idx) {
                                        pickedPropertiesIdx.remove(
                                            at: pickedPropertiesIdx.firstIndex(of: idx)!)
                                    } else {
                                        if pickedPropertiesIdx.count >= 2 {
                                            pickedPropertiesIdx.removeLast()
                                        }
                                        pickedPropertiesIdx.append(idx)
                                    }
                                }label:{
                                    //TODO: Replace with images and property name only later
                                    Text(wishlist.properties[idx].name)
                                        .font(.footnote).padding(5).foregroundStyle(.black).frame(
                                            width: 100, height: 70).bold()
                                }.border(
                                    pickedPropertiesIdx.contains(idx) ? .blue : .gray, width: 3)
                            }
                            Spacer()
                        }.background(Color.white.opacity(0.8))
                        Spacer()
                    }.zIndex(1)
                }
                WishlistPropertyComparisonView(properties: pickedProperties)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward.circle")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        showingChoice.toggle()
                    }
                } label: {
                    Image(systemName: showingChoice ? "minus.circle" : "plus.circle")
                }

            }
        }
    }
}

#Preview {
    WishlistDetailView(wishlist: Mock.Users[0].wishlists[0]).environmentObject(UserViewModel())
}
