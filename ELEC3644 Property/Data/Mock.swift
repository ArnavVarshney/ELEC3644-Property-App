//
//  Mock.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 24/10/24.
//

import Foundation

enum Mock {
    static var Properties: [Property] = [
        Property(
            name: "The Pavilia Hill",
            address: "18 Pak Tai Street, Ma On Shan",
            area: "Ma On Shan",
            district: "Sha Tin",
            subDistrict: "Ma On Shan",
            facilities: [
                Facility(desc: "Swimming Pool", measure: 1, measureUnit: "unit")
            ],
            schoolNet: SchoolNet(primary: "89", secondary: "89"),
            saleableArea: 500,
            saleableAreaPricePerSquareFoot: 15000,
            grossFloorArea: 600,
            grossFloorAreaPricePerSquareFoot: 13000,
            netPrice: "7,500,000",
            buildingAge: 5,
            buildingDirection: "North",
            estate: "The Pavilia Hill",
            imageUrls: [
                "https://chat-server.home-nas.xyz/images/Property1.jpg",
                "https://chat-server.home-nas.xyz/images/Property2.jpg",
                "https://chat-server.home-nas.xyz/images/Property3.jpg",
                "https://chat-server.home-nas.xyz/images/Property4.jpg",
                "https://chat-server.home-nas.xyz/images/Property5.jpg",
            ],
            transactionHistory: [
                Transaction(date: Date(), price: 7_500_000)
            ]
        ),
        Property(
            name: "The Pavilia Hill 2",
            address: "18 Pak Tai Street, Ma On Shan",
            area: "Ma On Shan",
            district: "Sha Tin",
            subDistrict: "Ma On Shan",
            facilities: [
                Facility(desc: "Swimming Pool", measure: 1, measureUnit: "unit")
            ],
            schoolNet: SchoolNet(primary: "89", secondary: "89"),
            saleableArea: 500,
            saleableAreaPricePerSquareFoot: 15000,
            grossFloorArea: 600,
            grossFloorAreaPricePerSquareFoot: 13000,
            netPrice: "7,500,000",
            buildingAge: 5,
            buildingDirection: "North",
            estate: "The Pavilia Hill",
            imageUrls: [
                "https://chat-server.home-nas.xyz/images/Property1.jpg",
                "https://chat-server.home-nas.xyz/images/Property2.jpg",
                "https://chat-server.home-nas.xyz/images/Property3.jpg",
                "https://chat-server.home-nas.xyz/images/Property4.jpg",
                "https://chat-server.home-nas.xyz/images/Property5.jpg",
            ],
            transactionHistory: [
                Transaction(date: Date(), price: 7_500_000)
            ]
        ),
    ]

    static var Chats: [Chat] = [
        Chat(
            user: Users[0],
            messages: [
                Message(
                    timestamp: Date(), senderId: "10530025-4005-4c89-b814-b0ea9e389343",
                    receiverId: "10530025-4005-4c89-b814-b0ea9e389343", content: "Hello!")
            ]),
        Chat(
            user: Users[1],
            messages: [
                Message(
                    timestamp: Date(), senderId: "10530025-4005-4c89-b814-b0ea9e389343",
                    receiverId: "10530025-4005-4c89-b814-b0ea9e389343", content: "Hi!")
            ]),
    ]

    static var Users: [User] = [
        User(
            name: "Filbert Tejalaksana", email: "a@gmail.com",
            avatarUrl:
                "https://media.licdn.com/dms/image/v2/C4D03AQFt9Bjg0CPk4Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1662615657137?e=2147483647&v=beta&t=sTx8Vlvu9gfvGVz1TO4GIavJPkqZ38kAd5-Lt8eGpq8",
            reviews: nil,
            wishlists: [
                Wishlist(name: "Holiday", properties: [Properties[0], Properties[1]]),
                Wishlist(name: "Home", properties: [Properties[0]]),
            ]
        ),
        User(
            name: "Abel Haris Harsono", email: "b@gmail.com",
            avatarUrl: "", reviews: nil, wishlists: nil),
    ]
    
    static var Agents: [User] = [
        User(
            name: "Agent Numero Uno", email: "agent1@agency1.agents",
            avatarUrl: "https://static.thenounproject.com/png/5147395-512.png",
            reviews: nil,
            wishlists: nil
        )
    ]
}
