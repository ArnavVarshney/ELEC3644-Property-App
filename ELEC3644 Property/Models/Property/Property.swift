//
//  Property.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import Foundation

struct Property: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let address: String
    let area: String
    let district: String
    let subDistrict: String

    let facilities: [Facility]
    let schoolNet: SchoolNet

    let saleableArea: Int
    let saleableAreaPricePerSquareFoot: Int
    let grossFloorArea: Int
    let grossFloorAreaPricePerSquareFoot: Int
    let netPrice: String

    let buildingAge: Int
    let buildingDirection: String
    let estate: String

    var transactionHistory: [Transaction]

    private enum CodingKeys: String, CodingKey {
        case name, address, area, district, subDistrict, facilities, schoolNet,
             saleableArea, saleableAreaPricePerSquareFoot, grossFloorArea, grossFloorAreaPricePerSquareFoot,
             netPrice, buildingAge, buildingDirection, estate, transactionHistory
    }
}

struct Transaction: Identifiable, Hashable, Codable {
    var id = UUID()
    let date: Date
    let price: Int

    private enum CodingKeys: String, CodingKey { case date, price }
}
