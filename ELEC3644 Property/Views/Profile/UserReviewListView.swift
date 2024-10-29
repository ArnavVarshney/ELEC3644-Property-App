//
//  UserReviewListView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import SwiftUI

struct UserReviewListView: View {
    var user: User

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 24) {
                ForEach(user.reviews, id: \.id) { review in
                    UserReviewCardView(
                        review: review
                    )
                }
            }
        }
        .frame(height: 310)
        .padding(.bottom, 4)
        .padding(.horizontal, 24)
    }
}

#Preview {
    struct UserReviewListView_Preview: View {
        @EnvironmentObject var userViewModel: UserViewModel

        var body: some View {
            UserReviewListView(user: userViewModel.user)
        }
    }
    return UserReviewListView_Preview()
        .environmentObject(UserViewModel())
}
