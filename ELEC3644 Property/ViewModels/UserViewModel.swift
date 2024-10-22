//
//  UserViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    var currentUserId: String = "10530025-4005-4c89-b814-b0ea9e389343"
    @Published var user: User = .init(name: "", email: "", avatarUrl: "", reviews: [])
    @Published var otherUsers: [User] = []

    init() {
        Task {
            await fetchUser(with: currentUserId)
        }
    }

    func fetchUser(with id: String) async {
        do {
            let fetchedUser = try await UserViewModel.getUser(with: id)
            DispatchQueue.main.async {
                self.user = fetchedUser
                self.fetchReviewAuthors()
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }

    func fetchReviewAuthors() {
        Task {
            do {
                let reviews = try await UserViewModel.getReviews(with: currentUserId)
                DispatchQueue.main.async {
                    self.user.reviews = reviews
                }
            } catch {
                print("Error fetching review author: \(error)")
            }
        }
    }

    static func getUser(with id: String) async throws -> User {
        guard let url = URL(string: "https://chat-server.home-nas.xyz/users/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(User.self, from: data)
    }

    static func getReviews(with id: String) async throws -> [Review] {
        guard let url = URL(string: "https://chat-server.home-nas.xyz/reviews/user/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode([Review].self, from: data)
    }

    static func averageRating(for user: User) -> Double {
        guard !user.reviews.isEmpty else { return 0 }
        let totalRating = user.reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(user.reviews.count)
    }
}
