//
//  UserReviewCardView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//
import SwiftUI

struct UserReviewCardView: View {
    var review: Review
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: review.timestamp, relativeTo: Date())
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("\"\(review.content)\"")
                .font(.subheadline)
                .foregroundColor(.neutral100)
            Spacer()
            HStack(alignment: .center) {
                UserAvatarView(user: review.author, size: 48)
                    .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.author.name)
                            .font(.footnote)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Rating: ")
                            .font(.footnote)
                            .fontWeight(.bold)
                        ForEach(0..<Int(review.rating)) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.neutral100)
                                .padding(-3)
                        }
                    }
                    Text(relativeTime)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.neutral70)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .frame(width: 300, height: 200)
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
            if let user = userViewModel.user.reviews.first {
                UserReviewCardView(
                    review: user
                )
            } else {
                Text("No reviews available")
            }
        }
    }
    return UserReviewCardView_Preview()
        .environmentObject(UserViewModel())
}
