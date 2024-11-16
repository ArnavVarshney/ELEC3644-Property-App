//
//  UserViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//
import Foundation

class UserViewModel: ObservableObject {
    private let apiClient: APIClient
    static let shared = UserViewModel()
    @Published var user = User(
        name: "", email: "", phone: "", avatarUrl: "", reviews: [], wishlists: []
    )
    @Published var otherUsers: [User] = []
    @Published var agents: [User] = []
    @Published var userRole: UserRole = .guest
    init(apiClient: APIClient = NetworkManager(), user: User? = nil) {
        self.apiClient = apiClient
        self.user.id = UUID(
            uuidString: UserDefaults.standard.string(forKey: "currentUserID") ?? defaultUUID)!
        if isLoggedIn() {
            Task {
                await self.fetchUser(with: self.currentUserId())
                await self.fetchWishlist()
            }
        }
    }

    func currentUserId() -> String {
        return user.id.uuidString.lowercased()
    }

    func isLoggedIn() -> Bool {
        return currentUserId() != defaultUUID
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

    func fetchWishlist() async {
        do {
            let json: [String: [Property]] = try await apiClient.get(
                url: "/wishlists/\(currentUserId())")
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
                "userId": currentUserId(), "propertyId": "\(property.dbId)".lowercased(),
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
        let apiClient = NetworkManager()
        let data = ["email": email, "password": password]
        let user: User = try await apiClient.post(url: "/users/login", body: data)
        return user
    }

    func logout() {
        user = User(
            name: "", email: "", phone: "", avatarUrl: "", reviews: [], wishlists: []
        )
        UserDefaults.standard.removeObject(forKey: "currentUserID")
    }

    static func register(with name: String, email: String, phone: String, password: String)
        async throws -> User
    {
        let apiClient = NetworkManager()
        let data = [
            "name": name, "email": email, "phone": phone, "password": password,
        ]
        let newUser: User = try await apiClient.post(url: "/users", body: data)
        return newUser
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
