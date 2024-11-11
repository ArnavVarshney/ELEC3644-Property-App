//
//  UserViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    private let apiClient: APIClient
    var currentUserId: String = "10530025-4005-4c89-b814-b0ea9e389343"
    @Published var user: User = .init(
        name: "", email: "", avatarUrl: "", reviews: [], wishlists: [])
    @Published var otherUsers: [User] = []
    @Published var agents: [User] = []
    @Published var userRole: UserRole = .guest

    init(apiClient: APIClient = NetworkManager(), user: User? = nil) {
        self.apiClient = apiClient
        if user != nil {
            self.user = user!
        } else {
            Task {
                await self.fetchUser(with: self.currentUserId)
                await fetchWishlist(with: self.currentUserId)
            }
        }
        if user != nil {
            if user!.email.contains("agent") {
                self.userRole = .agent
            }
        }
    }

    func fetchUser(with id: String) async {
        do {
            let user: User = try await apiClient.get(url: "/users/\(id)")
            let reviews: [Review] = try await apiClient.get(url: "/reviews/user/\(id)")
            DispatchQueue.main.async {
                self.user = user
                self.user.reviews = reviews
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }

    func fetchWishlist(with id: String) async {
        do {
            let json: [String: [Property]] = try await apiClient.get(url: "/wishlists/\(id)")
            let folderNames = json.keys
            let wishlists = folderNames.map { Wishlist(name: $0, properties: json[$0]!) }
            DispatchQueue.main.async {
                self.user.wishlists = wishlists
            }
        } catch {
            print("Error fetching user's wishlist data: \(error)")
        }
    }

    func postWishlist(property: Property, folderName: String, delete: Bool = false) async {
        do {
            let data = [
                "userId": currentUserId, "propertyId": "\(property.dbId)".lowercased(),
                "folderName": folderName.lowercased(),
            ]

            if delete {
                let _: DeleteResponse = try await apiClient.delete(url: "/wishlists", body: data)
            } else {
                let _: [String: String] = try await apiClient.post(url: "/wishlists", body: data)
            }
        } catch {
            print("Error pushing user's wishlist data: \(error)")
        }
    }

    static func login(with email: String, password: String) async throws -> User {
        guard let url = URL(string: "https://chat-server.home-nas.xyz/users/login") else {
            throw URLError(.badURL)
        }

        let body = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(User.self, from: data)
    }

    static func averageRating(for user: User) -> Double {
        guard !user.reviews.isEmpty else { return 0 }
        let totalRating = user.reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(user.reviews.count)
    }
}

struct DeleteResponse: Codable {
    let affected: Int?
    let message: String?
}
