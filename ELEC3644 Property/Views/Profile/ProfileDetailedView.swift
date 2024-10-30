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

    @Environment(\.dismiss) private var dismiss

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

                Section {
                    HStack(alignment: .center) {
                        Text("Rating:")
                        Spacer()
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(star <= rating ? .primary60 : .neutral60)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
                Divider()

                Button(action: {
                    submitReview()
                    dismiss()
                }) {
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
    @State private var showReviewsModal: Bool = false
    @State private var showWriteReviewModal: Bool = false
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
                    showReviewsModal = true
                }
                .foregroundColor(.black)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.neutral100)
                .padding(12)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top, 18)
            }

            if user.id != userViewModel.user.id {
                Button("Write a review") {
                    showWriteReviewModal = true
                }
                .foregroundColor(.black)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.neutral100)
                .padding(12)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top, 4)
            }
            Spacer()
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
        }.sheet(isPresented: $showReviewsModal) {
            ReviewsListModal(user: user)
        }.sheet(isPresented: $showWriteReviewModal) {
            ReviewFieldView(user: user)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ReviewsListModal: View {
    var user: User
    @EnvironmentObject private var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(user.reviews, id: \.id) { review in
                        VStack(alignment: .leading) {
                            HStack {
                                UserAvatarView(user: review.author, size: 36)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(review.author.name)
                                        .font(.system(size: 18, weight: .bold))
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                        Text("\(Int(review.rating))")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                }
                                Spacer()
                            }
                            Text(review.content)
                                .padding(.top, 12)
                        }
                        .padding(.vertical)
                        Divider()
                    }
                    Spacer()
                }
                .navigationTitle("\(user.reviews.count) Review\(user.reviews.count > 1 ? "s" : "")")
                .padding(.horizontal, 24)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: 18, height: 18)
                                .foregroundColor(.black)
                                .padding(12)
                        }
                    }
                })
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
