//
//  UserViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import Foundation

struct UserData: Codable {
    let user: User
    let otherUsers: [User]
}

class UserViewModel: ObservableObject {
    @Published var user: User = .init(name: "", email: "", avatarUrl: "", reviews: [])
    @Published var otherUsers: [User] = []

    init() {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            print("User data file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let userData = try decoder.decode(UserData.self, from: data)
            self.user = userData.user
            self.otherUsers = userData.otherUsers
        } catch {
            print("Error decoding user data: \(error)")
        }
    }

    static func averageRating(for user: User) -> Double {
        if user.reviews.count == 0 {
            return 0
        }
        let totalRating = user.reviews.reduce(0) { result, review in
            result + review.rating
        }

        let result: Double = totalRating / Double(user.reviews.count)
        return result
    }
}
