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
}

struct Review: Identifiable, Codable {
    var id = UUID()
    var author: String
    var rating: Double
    var comment: String

    private enum CodingKeys: String, CodingKey { case author, rating, comment }
}
