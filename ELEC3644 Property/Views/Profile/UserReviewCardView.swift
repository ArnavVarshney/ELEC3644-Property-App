//
//  UserReviewCardView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import SwiftUI

struct UserReviewCardView: View {
    @Binding var review: Review
    @Binding var author: User

    var body: some View {
        VStack(alignment: .leading) {
            Text("\"\(review.comment)\"")
                .font(.subheadline)
                .foregroundColor(.neutral100)
            Spacer()
            HStack(alignment: .center) {
                UserAvatarView(user: author, size: 36)
                VStack(alignment: .leading) {
                    Text(author.name)
                        .font(.headline)
                    HStack {
                        Text(String(format: "%.2f", review.rating))
                            .font(.headline)
                            .foregroundColor(.primary60)
                        Image(systemName: "star.fill")
                            .foregroundColor(.primary60)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.all, 12)
        .frame(width: 200, height: 310)
        .background(.neutral10)
        .overlay(
            RoundedRectangle(cornerRadius: 12).inset(by: 1)
                .strokeBorder(.neutral30, lineWidth: 1)
        )
    }
}

#Preview {
    struct UserReviewCardView_Preview: View {
        @EnvironmentObject var userViewModel: UserViewModel

        var body: some View {
            UserReviewCardView(
                review: $userViewModel.user.reviews.first!,
                author: $userViewModel.otherUsers.first(where: {
                    $0.name.wrappedValue == $userViewModel.user.reviews.first!.author.wrappedValue
                })!
            )
        }
    }
    return UserReviewCardView_Preview()
        .environmentObject(UserViewModel())
}
