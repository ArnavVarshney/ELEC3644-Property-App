//
//  User.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var avatarUrl: String
    var reviews: [Review]
    var wishlists: [Wishlist]
    var role: String = "Guest"

    private enum CodingKeys: String, CodingKey {
        case name, email, avatarUrl, reviews, wishlists, id
    }

    // both of these initializers are made to enforce that reviews will never be nil
    init(
        name: String, email: String, avatarUrl: String, reviews: [Review]?, wishlists: [Wishlist]?,
        id: String? = nil
    ) {
        self.name = name
        self.email = email
        self.avatarUrl = avatarUrl
        self.reviews = reviews ?? []
        self.wishlists = wishlists ?? []
        self.id = UUID(uuidString: id ?? "") ?? UUID()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        reviews = try container.decodeIfPresent([Review].self, forKey: .reviews) ?? []
        wishlists = try container.decodeIfPresent([Wishlist].self, forKey: .wishlists) ?? []
        if email.contains("agent") {
            role = "Agent"
        } else if email.contains("host") {
            role = "Host"
        }

    }
}

struct Review: Identifiable, Codable {
    var id = UUID()
    var author: User
    var rating: Double
    var content: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(User.self, forKey: .author)
        rating = try container.decode(Double.self, forKey: .rating)
        content = try container.decode(String.self, forKey: .content)
    }

    init(author: User, rating: Double, content: String) {
        self.author = author
        self.rating = rating
        self.content = content
    }

    private enum CodingKeys: String, CodingKey { case author, rating, content }
}

struct Wishlist: Identifiable, Codable {
    var id = UUID()
    var name: String
    var properties: [Property]

    private enum CodingKeys: String, CodingKey { case name, properties }
}
