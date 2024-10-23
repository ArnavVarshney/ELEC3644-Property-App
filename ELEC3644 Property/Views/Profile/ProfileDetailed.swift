//
//  ProfileDetailed.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import SwiftUI

struct ProfileDetailed: View {
  @StateObject var userViewModel: UserViewModel
  @Environment(\.dismiss) private var dismiss

  var user: User {
    userViewModel.user
  }

  var body: some View {
    VStack {
      UserAvatarView(user: user, size: 48)
      Text(user.name)
        .font(.headline)
      Text(user.email)
        .font(.subheadline)
      HStack(spacing: 24) {
        HStack {
          Text("\(user.reviews.count)")
            .font(.headline)
          Text("Reviews")
            .font(.subheadline)
        }
        HStack {
          Text(String(format: "%.2f", UserViewModel.averageRating(for: user)))
            .font(.headline)
          Text("Rating")
            .font(.subheadline)
        }
      }.padding(.top, 12)

      UserReviewListView(userViewModel: userViewModel)
      Spacer()
    }
    .padding(.horizontal, 24)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button("Back") {
          dismiss()
        }.foregroundColor(.primary60)
      }
    }
  }
}

#Preview {
  struct ProfileDetailed_Preview: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
      ProfileDetailed(userViewModel: userViewModel)
    }
  }
  return ProfileDetailed_Preview()
    .environmentObject(UserViewModel())
}
