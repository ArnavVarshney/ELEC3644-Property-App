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
  let property: Property

  var body: some View {
    Form {
      Section(header: Text("Enter album name")) {
        TextField("Pick an album name", text: $albumName)
      }
      Button {
        let temp = albumName == "" ? "Default" : albumName
        let idxs = userViewModel.user.wishlists.enumerated().map({ $1.name == temp ? $0 : -1 })
          .filter({ $0 != -1 })
        if idxs.isEmpty {
          userViewModel.user.wishlists.append(Wishlist(name: temp, properties: [property]))
        } else {
          let idx = idxs[0]
          userViewModel.user.wishlists[idx].properties.append(property)
        }
        dismiss()
      } label: {
        HStack {
          Spacer()
          Text("Save").foregroundStyle(.blue)
          Spacer()
        }
      }

    }
  }
}

#Preview {
  FavoriteSubmitForm(property: Mock.Properties[0]).environmentObject(UserViewModel())
}
