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
            Button(action: {
                let temp = albumName == "" ? "Default" : albumName
                Task {
                    await userViewModel.postWishlist(property: property, folderName: temp)
                    await userViewModel.fetchWishlist(with: userViewModel.currentUserId)
                }

                withAnimation {
                    dismiss()
                }
            }) {
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
