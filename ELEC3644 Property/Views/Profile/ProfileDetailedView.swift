//
//  ProfileDetailedView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import SwiftUI

struct ReviewFieldView: View {
    @State private var reviewText: String = ""
    @State private var rating: Int = 0
    @EnvironmentObject private var agentViewModel: AgentViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    var user: User

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Section {
                    TextField("Write your review here...", text: $reviewText)
                        .padding()
                        .frame(height: 120, alignment: .top)
                        .scrollContentBackground(.hidden)
                        .background(.neutral20)
                        .cornerRadius(12)
                }

                HStack {
                    Text("Rating:")
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(star <= rating ? .primary60 : .neutral60)
                            .onTapGesture {
                                rating = star
                            }
                    }
                }

                Button(action: submitReview) {
                    Text("Submit Review")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.primary60)
                        .foregroundColor(.neutral10)
                        .cornerRadius(8)
                }
                .disabled(reviewText.isEmpty || rating == 0)
            }
            .padding()
        }
    }

    private func submitReview() {
        let newReview = Review(
            author: userViewModel.user,
            rating: Double(rating),
            content: reviewText)

        Task {
            await agentViewModel.writeReview(review: newReview, reviewedUserId: user.id)
            reviewText = ""
            rating = 0
        }

        if let reviewedUser = agentViewModel.agents.firstIndex(where: { $0.id == user.id }) {
            agentViewModel.agents[reviewedUser].reviews.append(newReview)
        }
    }
}

struct ProfileDetailedView: View {
    var user: User
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: UserViewModel
    var firstName: String {
        if user.name.split(separator: " ").count > 1 {
            return String(user.name.split(separator: " ")[0])
        } else {
            return user.name
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 36) {
                Spacer()
                VStack {
                    UserAvatarView(user: user, size: 100)
                    Text(firstName)
                        .font(.system(size: 24, weight: .bold))

                    Text(user.role)
                        .font(.system(size: 12, weight: .semibold))
                }

                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(user.reviews.count)")
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("Reviews")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(String(format: "%.2f", UserViewModel.averageRating(for: user)))
                                .font(.headline)
                                .fontWeight(.bold)

                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 12, height: 12)
                        }
                        Text("Rating")
                            .font(.system(size: 12, weight: .semibold))
                    }
                }
                .padding(.top, 12)
                .frame(maxWidth: 100)
                Spacer()
            }
            .padding(24)

            if user.reviews.count > 0 {
                Text("\(firstName)'s reviews")
                    .font(.title3)
                    .fontWeight(.semibold)

                UserReviewListView(user: user)
                    .padding(.top, 12)
            }

            if user.reviews.count > 1 {
                Button("Show all \(user.reviews.count) reviews") {
                    // Show all reviews
                }
                .foregroundColor(.black)
                .font(.system(size: 15, weight: .semibold))
                .padding(12)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top, 18)
            }

            Spacer()

            if user.id != userViewModel.user.id {
                ReviewFieldView(user: user)
            }
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                        .padding(12)
                }
            }
        }
    }
}

#Preview {
    struct ProfileDetailedView_Preview: View {
        @State var user: User = Mock.Users.first!

        var body: some View {
            ProfileDetailedView(user: user)
        }
    }
    return ProfileDetailedView_Preview()
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
