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
    let netPrice: Int
    let buildingAge: Int
    let buildingDirection: String
    let estate: String
    var imageUrls: [String]
    var vrImageUrls: [VRImage]
    var transactionHistory: [Transaction]
    var agent: User
    let amenities: [String]
    let propertyType: String
    let contractType: String
    let isActive: Bool
    private enum CodingKeys: String, CodingKey {
        case name, address, area, district, subDistrict, facilities, schoolNet,
            saleableArea, saleableAreaPricePerSquareFoot, grossFloorArea,
            grossFloorAreaPricePerSquareFoot,
            netPrice, buildingAge, buildingDirection, estate, imageUrls, vrImageUrls,
            transactionHistory, agent,
            propertyType, contractType, amenities, id, isActive
    }
}

struct PropertySearchField: Hashable {
    var lowerPrice: Double = 1_000
    var upperPrice: Double = 100_000_000
    var propertyType: String = "any"
    var area: String = "any"
    var district: String = "any"
    var subdistrict: String = "any"
    var amenities: Set<String> = []
    var contractType: String = "Buy"
}

struct Transaction: Identifiable, Hashable, Codable {
    var id = UUID()
    var date: Date
    var price: Int
    private enum CodingKeys: String, CodingKey { case date, price }
}

struct PropertyTransaction: Identifiable, Hashable {
    var id = UUID()
    var transaction: Transaction
    var property: Property
    var priceDelta: Int
    var pricePerSqft: Int {
        return transaction.price / property.saleableArea
    }
    var pricePerGrossArea: Int {
        return transaction.price / property.grossFloorArea
    }
}

struct SchoolNet: Identifiable, Hashable, Codable {
    var id = UUID()
    var primary: String
    var secondary: String
    private enum CodingKeys: String, CodingKey { case primary, secondary }
}

struct VRImage: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var url: String
    private enum CodingKeys: String, CodingKey { case name, url }
}

struct Facility: Identifiable, Hashable, Codable {
    var id = UUID()
    var desc: String
    var measure: Int
    var measureUnit: String
    private enum CodingKeys: String, CodingKey { case desc, measure, measureUnit }
}

struct Tag: Identifiable, Hashable {
    let id = UUID()
    let label: String
    var content: String?
}

struct Location: Identifiable, Hashable, Codable {
    var id = UUID()
    var area: String
    var district: String
    var subDistrict: String
    private enum CodingKeys: String, CodingKey { case area, district, subDistrict }
    static let areas: [String] = [
        "HK Island",
        "Kowloon",
        "New Territories",
    ]
    static let districts: [String: [String]] = [
        "HK Island": ["Central and Western", "Wan Chai", "Eastern", "Southern"],
        "Kowloon": ["Yau Tsim Mong", "Sham Shui Po", "Kowloon City", "Wong Tai Sin", "Kwun Tong"],
        "New Territories": [
            "Kwai Tsing", "Tsuen Wan", "Tuen Mun", "Yuen Long", "North", "Tai Po", "Sha Tin",
            "Sai Kung",
            "Islands",
        ],
    ]
    static let subDistricts: [String: [String]] = [
        // Hong Kong Island
        "Central and Western": [
            "Kennedy Town", "Shek Tong Tsui", "Sai Ying Pun", "Sheung Wan", "Central", "Admiralty",
            "Mid-levels", "Peak",
        ],
        "Wan Chai": [
            "Wan Chai", "Causeway Bay", "Happy Valley", "Tai Hang", "So Kon Po",
            "Jardine's Lookout",
        ],
        "Eastern": [
            "Tin Hau", "Braemar Hill", "North Point", "Quarry Bay", "Sai Wan Ho", "Shau Kei Wan",
            "Chai Wan", "Siu Sai Wan",
        ],
        "Southern": [
            "Pok Fu Lam", "Aberdeen", "Ap Lei Chau", "Wong Chuk Hang", "Shouson Hill",
            "Repulse Bay",
            "Chung Hom Kok", "Stanley", "Tai Tam", "Shek O",
        ],
        // Kowloon
        "Yau Tsim Mong": [
            "Tsim Sha Tsui", "Yau Ma Tei", "West Kowloon Reclamation", "King's Park", "Mong Kok",
            "Tai Kok Tsui",
        ],
        "Sham Shui Po": [
            "Mei Foo", "Lai Chi Kok", "Cheung Sha Wan", "Sham Shui Po", "Shek Kip Mei",
            "Yau Yat Tsuen",
            "Tai Wo Ping", "Stonecutters Island",
        ],
        "Kowloon City": [
            "Hung Hom", "To Kwa Wan", "Ma Tau Kok", "Ma Tau Wai", "Kai Tak", "Kowloon City",
            "Ho Man Tin",
            "Kowloon Tong", "Beacon Hill",
        ],
        "Wong Tai Sin": [
            "San Po Kong", "Wong Tai Sin", "Tung Tau", "Wang Tau Hom", "Lok Fu", "Diamond Hill",
            "Tsz Wan Shan", "Ngau Chi Wan",
        ],
        "Kwun Tong": [
            "Ping Shek", "Kowloon Bay", "Ngau Tau Kok", "Jordan Valley", "Kwun Tong",
            "Sau Mau Ping",
            "Lam Tin", "Yau Tong", "Lei Yue Mun",
        ],
        // New Territories
        "Kwai Tsing": ["Kwai Chung", "Tsing Yi"],
        "Tsuen Wan": [
            "Tsuen Wan", "Lei Muk Shue", "Ting Kau", "Sham Tseng", "Tsing Lung Tau", "Ma Wan",
            "Sunny Bay",
        ],
        "Tuen Mun": ["Tai Lam Chung", "So Kwun Wat", "Tuen Mun", "Lam Tei"],
        "Yuen Long": [
            "Hung Shui Kiu", "Ha Tsuen", "Lau Fau Shan", "Tin Shui Wai", "Yuen Long", "San Tin",
            "Lok Ma Chau", "Kam Tin", "Shek Kong", "Pat Heung",
        ],
        "North": [
            "Fanling", "Luen Wo Hui", "Sheung Shui", "Shek Wu Hui", "Sha Tau Kok", "Luk Keng",
            "Wu Kau Tang",
        ],
        "Tai Po": [
            "Tai Po Market", "Tai Po", "Tai Po Kau", "Tai Mei Tuk", "Shuen Wan", "Cheung Muk Tau",
            "Kei Ling Ha",
        ],
        "Sha Tin": ["Tai Wai", "Sha Tin", "Fo Tan", "Ma Liu Shui", "Wu Kai Sha", "Ma On Shan"],
        "Sai Kung": [
            "Clear Water Bay", "Sai Kung", "Tai Mong Tsai", "Tseung Kwan O", "Hang Hau",
            "Tiu Keng Leng",
            "Ma Yau Tong",
        ],
        "Islands": [
            "Cheung Chau", "Peng Chau", "Lantau Island (including Tung Chung)", "Lamma Island",
        ],
    ]
}
