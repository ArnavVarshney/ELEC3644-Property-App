//
//  WishlistsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 26/10/24.
//
import SwiftUI

struct WishlistsView: View {
  @EnvironmentObject var userViewModel: UserViewModel

  var user: User {
    userViewModel.user
  }

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        HStack(spacing: 12) {
          UserAvatarView(user: user)
          VStack(alignment: .leading) {
            Text(user.name)
              .font(.headline)
            Text(user.email)
              .font(.subheadline)
          }
          Spacer()
          NavigationLink(
            destination: ProfileDetailed(userViewModel: userViewModel),
            label: {
              Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .padding(10)
            })
        }
        Spacer()
      }
      .padding(.horizontal, 24)
      .navigationTitle("Wishlists")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(
            action: {
              ProfileView()
            },
            label: {
              Image(systemName: "square.and.pencil")
            })
        }
      }
    }
  }
}

#Preview {
  WishlistsView()
    .environmentObject(UserViewModel())
}
