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
      transactionHistory: [
        Transaction(date: Date(), price: 7_500_000)
      ]
    )
  ]

  static var Chats: [Chat] = [
    Chat(
      user: User(
        name: "Filbert Tejalaksana", email: "abc@gmail.com",
        avatarUrl:
          "https://media.licdn.com/dms/image/v2/C4D03AQFt9Bjg0CPk4Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1662615657137?e=2147483647&v=beta&t=sTx8Vlvu9gfvGVz1TO4GIavJPkqZ38kAd5-Lt8eGpq8",
        reviews: nil),
      messages: [
        Message(
          timestamp: Date(), senderId: "10530025-4005-4c89-b814-b0ea9e389343",
          receiverId: "10530025-4005-4c89-b814-b0ea9e389343", content: "Hello!")
      ]),
    Chat(
      user: User(
        name: "Abel Haris Harsono", email: "adc@gmail.com",
        avatarUrl: "", reviews: nil),
      messages: [
        Message(
          timestamp: Date(), senderId: "10530025-4005-4c89-b814-b0ea9e389343",
          receiverId: "10530025-4005-4c89-b814-b0ea9e389343", content: "Hi!")
      ]),
  ]
}
