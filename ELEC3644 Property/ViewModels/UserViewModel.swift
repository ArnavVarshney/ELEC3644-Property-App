//
//  UserViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User =
        .init(
            name: "Abel",
            email: "abel@gmail.com",
            avatarUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png",
            reviews: [
                Review(author: "Not Abel", rating: 1.2, comment: "Hello, this is a longer comment to test the display of the review card."),
                Review(author: "Abel?", rating: 3.0, comment: "Really?"),
                Review(author: "Bella", rating: 2.0, comment: "Huh, this needs some more text to see if it wraps correctly.")
            ]
        )

    @Published var otherUsers: [User] = [
        .init(
            name: "Bella",
            email: "bella@gmail.com",
            avatarUrl: "https://media.licdn.com/dms/image/v2/D5603AQG8tmfnr13yGw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1678022788922?e=2147483647&v=beta&t=3Fe9_TaNUeNuyYO86Q51Z_1U1psHBrRWLAi-7QRc_58",
            reviews: []
        ),
        .init(
            name: "Not Abel",
            email: "notabel@gmail.com",
            avatarUrl: "https://media.licdn.com/dms/image/v2/C4D03AQFt9Bjg0CPk4Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1662615657137?e=2147483647&v=beta&t=sTx8Vlvu9gfvGVz1TO4GIavJPkqZ38kAd5-Lt8eGpq8",
            reviews: []
        ),
        .init(
            name: "Abel?",
            email: "abelquestionmark@gmail.com",
            avatarUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png",
            reviews: []
        )
    ]

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
