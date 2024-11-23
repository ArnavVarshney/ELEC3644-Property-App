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
            id:UUID(uuidString: "c96e735d-fd0b-48f1-a40e-5cafa57dab31")!,
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
            netPrice: 7_500_000,
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
            ],
            agent: Mock.Agents[1],
            amenities: ["pet-friendly"],
            propertyType: "apartment",
            contractType: "Buy"
        ),
        Property(
            id: UUID(uuidString: "86c46f5f-0ff0-438b-873d-9e4e40beede7")!,
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
            netPrice: 7_500_000,
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
                Transaction(
                    date: Date(timeIntervalSince1970: 1_609_459_200),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_612_137_600),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_614_556_800),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_617_235_200),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_619_827_200),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_622_505_600),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_625_097_600),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_627_776_000),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_630_454_400),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_633_046_400),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
            ],
            agent: Mock.Agents[0],
            amenities: ["gym", "balcony"],
            propertyType: "townhouse",
            contractType: "Lease"
        ),
        Property(
            id: UUID(uuidString: "0e287890-277c-47fb-aafc-ff92ca770852")!,
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
            netPrice: 7_500_000,
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
                Transaction(
                    date: Date(timeIntervalSince1970: 1_609_459_200),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_612_137_600),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_614_556_800),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_617_235_200),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_619_827_200),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_622_505_600),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_625_097_600),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_627_776_000),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_630_454_400),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
                Transaction(
                    date: Date(timeIntervalSince1970: 1_633_046_400),
                    price: Int.random(in: 6_000_000...8_500_000)
                ),
            ],
            agent: Mock.Agents[0],
            amenities: ["gym", "balcony"],
            propertyType: "townhouse",
            contractType: "Lease"
        )
    ]
    static var Chats: [Chat] = [
        Chat(
            user: Users[0],
            messages: [
                Message(
                    timestamp: Date(), senderId: "10530025-4005-4c89-b814-b0ea9e389343",
                    receiverId: "10530025-4005-4c89-b814-b0ea9e389343", content: "Hello!"
                )
            ]
        ),
        Chat(
            user: Users[1],
            messages: [
                Message(
                    timestamp: Date(), senderId: "10530025-4005-4c89-b814-b0ea9e389343",
                    receiverId: "10530025-4005-4c89-b814-b0ea9e389343", content: "Hi!"
                )
            ]
        ),
    ]
    static var Users: [User] = [
        User(
            name: "Filbert Tejalaksana", email: "a@gmail.com",
            phone: "852 12345678",
            avatarUrl:
                "https://media.licdn.com/dms/image/v2/C4D03AQFt9Bjg0CPk4Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1662615657137?e=2147483647&v=beta&t=sTx8Vlvu9gfvGVz1TO4GIavJPkqZ38kAd5-Lt8eGpq8",
            reviews: [
                Review(
                    author: User(
                        name: "Abel Haris Harsono", email: "b@gmail.com",
                        phone: "852 12345678",
                        avatarUrl: "", reviews: nil, wishlists: nil
                    ),
                    rating: 2, content: "Testing"
                ),
                Review(
                    author: User(
                        name: "Abel Haris Harsono", email: "b@gmail.com",
                        phone: "852 12345678",
                        avatarUrl: "", reviews: nil, wishlists: nil
                    ),
                    rating: 2, content: "Testing"
                ),
                Review(
                    author: User(
                        name: "Abel Haris Harsono", email: "b@gmail.com",
                        phone: "852 12345678",
                        avatarUrl: "", reviews: nil, wishlists: nil
                    ),
                    rating: 2, content: "Testing"
                ),
            ],
            wishlists: [
                Wishlist(name: "Holiday", properties: [Properties[0], Properties[1]]),
                Wishlist(name: "Home", properties: [Properties[0]]),
            ],
            id: "68b696d7-320b-4402-a412-d9cee10fc6a3"
        ),
        User(
            name: "Abel Haris Harsono", email: "b@gmail.com",
            phone: "852 12345678",
            avatarUrl: "", reviews: nil, wishlists: nil
        ),
    ]
    static var Agents: [User] = [
        User(
            name: "Agent Numero Uno", email: "agent1@agency1.agents",
            phone: "852 12345678",
            avatarUrl: "https://static.thenounproject.com/png/5147395-512.png",
            reviews: nil,
            wishlists: nil
        ),
        User(
            name: "Agent Numero Dos", email: "agent2@agency2.agents",
            phone: "852 12345678",
            avatarUrl: "https://static.thenounproject.com/png/5147395-512.png",
            reviews: nil,
            wishlists: nil
        ),
    ]
}

let mockPropertyImages = [
    "Property1",
    "Property2",
    "Property3",
    "Property4",
    "Property5",
]
let defaultUUID = "00000000-0000-0000-0000-000000000000"
