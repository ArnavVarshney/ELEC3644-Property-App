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
    @State private var isLoading = false
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
                                .foregroundColor(star <= rating ? .black : .neutral60)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
                Divider()
                    .padding(.vertical)
                Button(action: {
                    submitReview()
                    dismiss()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                    } else {
                        Text("Submit Review")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.neutral100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                    }
                }
                .background(Color.black)
                .cornerRadius(8)
                .disabled(reviewText.isEmpty || rating == 0)
                Spacer()
            }
            .navigationTitle("Review \(user.firstName())")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
        }
    }

    private func submitReview() {
        isLoading = true
        let newReview = Review(
            author: userViewModel.user,
            rating: Double(rating),
            content: reviewText
        )
        Task {
            await agentViewModel.writeReview(review: newReview, reviewedUserId: user.id)
            reviewText = ""
            rating = 0
            isLoading = false
        }
        if let reviewedUser = agentViewModel.agents.firstIndex(where: { $0.id == user.id }) {
            agentViewModel.agents[reviewedUser].reviews.append(newReview)
        }
    }
}

struct ProfileDetailedView: View {
    @State var user: User
    @State private var showReviewsModal: Bool = false
    @State private var showWriteReviewModal: Bool = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: UserViewModel

    var body: some View {
        ScrollView {
            VStack {
                HStack(spacing: 60) {
                    VStack {
                        UserAvatarView(user: user, size: 100)
                        Text(user.firstName())
                            .font(.system(size: 24, weight: .bold))
                        if userViewModel.user.id == user.id {
                            switch userViewModel.userRole {
                            case .agent:
                                Text("Agent")
                                    .font(.system(size: 12, weight: .semibold))
                            case .host:
                                Text("Host")
                                    .font(.system(size: 12, weight: .semibold))
                            default:
                                Text("Guest")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                        } else {
                            Text("Agent")
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                    .padding(.leading, 36)
                    .padding(.vertical, 24)
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
                    .padding(.trailing, 36)
                    .frame(maxWidth: 100)
                }
                .background(.white)
                .cornerRadius(24)
                .addShadow()
                .padding(.vertical, 24)
                if user.reviews.count > 0 {
                    HStack {
                        Text("\(user.firstName())'s reviews")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                    }
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
                    Button(action: {
                        showWriteReviewModal = true
                    }) {
                        Text("Write a review")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.neutral100)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                    }
                    .background(Color.black)
                    .cornerRadius(8)
                    .padding(.top, 18)
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
                    .presentationDetents([.medium])
            }
            .onAppear {
                if user.id.uuidString.lowercased() != userViewModel.currentUserId() {
                    Task {
                        user.reviews = try await NetworkManager.shared.get(
                            url: "/reviews/user/\(user.id.uuidString.lowercased())")
                    }
                }
            }
        }
        .refreshable {
            userViewModel.initTask()
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
                        var relativeTime: String {
                            let formatter = RelativeDateTimeFormatter()
                            formatter.unitsStyle = .full
                            return formatter.localizedString(
                                for: review.timestamp, relativeTo: Date())
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                UserAvatarView(user: review.author, size: 48)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(review.author.name)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("Rating: ")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                        ForEach(0..<5, id: \.self) { index in
                                            Image(systemName: "star.fill")
                                                .resizable()
                                                .frame(width: 12, height: 12)
                                                .foregroundColor(.black)
                                                .padding(-3)
                                                .opacity(index < Int(review.rating) ? 1 : 0)
                                        }
                                    }
                                    Text(relativeTime)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.neutral60)
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
