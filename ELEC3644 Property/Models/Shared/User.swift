//
//  User.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

struct User: Hashable, Decodable {
    var id = UUID()
    var name: String
    var email: String
    var avatarUrl: String
    var reviews: [Review]
}

struct Review: Hashable, Decodable {
    var id = UUID()
    var author: String
    var rating: Double
    var comment: String
}
