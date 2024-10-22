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

    private enum CodingKeys: String, CodingKey { case name, email, avatarUrl, reviews }

    // both of these initializers are made to enforce that reviews will never be nil
    init(name: String, email: String, avatarUrl: String, reviews: [Review]?) {
        self.name = name
        self.email = email
        self.avatarUrl = avatarUrl
        self.reviews = reviews ?? []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        reviews = try container.decodeIfPresent([Review].self, forKey: .reviews) ?? []
    }
}

struct Review: Identifiable, Codable {
    var id = UUID()
    var author: User
    var rating: Double
    var content: String

    private enum CodingKeys: String, CodingKey { case author, rating, content }
}
