//
//  UserReviewListView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import SwiftUI

struct UserReviewListView: View {
  @StateObject var userViewModel: UserViewModel

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 24) {
        ForEach($userViewModel.user.reviews, id: \.id) { review in
          UserReviewCardView(
            review: review
          )
        }
      }
    }
    .frame(width: .infinity, height: 310)
    .padding(.bottom, 4)
    .padding(.horizontal, 24)
  }
}

#Preview {
  struct UserReviewListView_Preview: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
      UserReviewListView(userViewModel: userViewModel)
    }
  }
  return UserReviewListView_Preview()
    .environmentObject(UserViewModel())
}
