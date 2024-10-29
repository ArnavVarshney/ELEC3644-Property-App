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
        }}
    
    private func submitReview() {
        let newReview = Review(author: userViewModel.user,
                            rating: Double(rating),
                            content: reviewText)
        
        Task {
            await agentViewModel.writeReview(review: newReview, reviewedUserId: user.id)
            reviewText = ""
            rating = 0
        }
        
        if let reviewedUser = agentViewModel.agents.firstIndex(where: { $0.id == user.id}) {
            agentViewModel.agents[reviewedUser].reviews.append(newReview)
        }
    }
}

struct ProfileDetailedView: View {
    var user: User
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: UserViewModel

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

            UserReviewListView(user: user)
            Spacer()
            
            if (user.id != userViewModel.user.id) {
                ReviewFieldView(user: user)
            }
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
        .toolbarVisibility(.visible)
    }
}

#Preview {
    struct ProfileDetailedView_Preview: View {
        @State var user: User = Mock.Agents.first!
        
        var body: some View {
            ProfileDetailedView(user: user)
        }
    }
    return ProfileDetailedView_Preview()
        .environmentObject(UserViewModel())
        .environmentObject(AgentViewModel())
}
