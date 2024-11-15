//
//  User.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

enum UserRole: String, Codable {
    case guest, host, agent
}

struct User: Hashable, Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var phone: String
    var avatarUrl: String
    var reviews: [Review]
    var wishlists: [Wishlist]

    private enum CodingKeys: String, CodingKey {
        case name, email, phone, avatarUrl, reviews, wishlists, id
    }

    // both of these initializers are made to enforce that reviews will never be nil
    init(
        name: String, email: String, phone: String?, avatarUrl: String, reviews: [Review]?,
        wishlists: [Wishlist]?,
        id: String? = nil
    ) {
        self.name = name
        self.email = email
        self.phone = phone ?? ""
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
        phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        reviews = try container.decodeIfPresent([Review].self, forKey: .reviews) ?? []
        wishlists = try container.decodeIfPresent([Wishlist].self, forKey: .wishlists) ?? []
    }
}

struct Review: Hashable, Identifiable, Codable {
    var id = UUID()
    var author: User
    var rating: Double
    var content: String
    var timestamp = Date()

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(User.self, forKey: .author)
        rating = try container.decode(Double.self, forKey: .rating)
        content = try container.decode(String.self, forKey: .content)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    init(author: User, rating: Double, content: String, timestamp: Date = Date()) {
        self.author = author
        self.rating = rating
        self.content = content
        self.timestamp = timestamp
    }

    private enum CodingKeys: String, CodingKey { case author, rating, content, timestamp }
}

struct Wishlist: Hashable, Identifiable, Codable {
    var id = UUID()
    var name: String
    var properties: [Property]

    private enum CodingKeys: String, CodingKey { case name, properties }
}
