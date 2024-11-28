//
//  Property.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import Foundation

struct Property: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var address: String
    var area: String
    var district: String
    var subDistrict: String
    var facilities: [Facility]
    var schoolNet: SchoolNet
    var saleableArea: Int
    var saleableAreaPricePerSquareFoot: Int
    var grossFloorArea: Int
    var grossFloorAreaPricePerSquareFoot: Int
    var netPrice: Int
    var buildingAge: Int
    var buildingDirection: String
    var estate: String
    var imageUrls: [String]
    var vrImageUrls: [VRImage]
    var transactionHistory: [Transaction]
    var agent: User
    var amenities: [String]
    var propertyType: String
    var contractType: String
    var isActive: Bool
    private enum CodingKeys: String, CodingKey {
        case name, address, area, district, subDistrict, facilities, schoolNet,
            saleableArea, saleableAreaPricePerSquareFoot, grossFloorArea,
            grossFloorAreaPricePerSquareFoot,
            netPrice, buildingAge, buildingDirection, estate, imageUrls, vrImageUrls,
            transactionHistory, agent,
            propertyType, contractType, amenities, id, isActive
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(area, forKey: .area)
        try container.encode(district, forKey: .district)
        try container.encode(subDistrict, forKey: .subDistrict)

        let facilitiesData = try JSONEncoder().encode(facilities)
        if let facilitiesString = String(data: facilitiesData, encoding: .utf8) {
            try container.encode(facilitiesString, forKey: .facilities)
        }

        let schoolNetData = try JSONEncoder().encode(schoolNet)
        if let schoolNetString = String(data: schoolNetData, encoding: .utf8) {
            try container.encode(schoolNetString, forKey: .schoolNet)
        }

        try container.encode(saleableArea, forKey: .saleableArea)
        try container.encode(
            saleableAreaPricePerSquareFoot, forKey: .saleableAreaPricePerSquareFoot)
        try container.encode(grossFloorArea, forKey: .grossFloorArea)
        try container.encode(
            grossFloorAreaPricePerSquareFoot, forKey: .grossFloorAreaPricePerSquareFoot)
        try container.encode(netPrice, forKey: .netPrice)
        try container.encode(buildingAge, forKey: .buildingAge)

        try container.encode(buildingDirection, forKey: .buildingDirection)
        try container.encode(estate, forKey: .estate)

        let imageUrlsData = try JSONEncoder().encode(imageUrls)
        if let imageUrlsString = String(data: imageUrlsData, encoding: .utf8) {
            try container.encode(imageUrlsString, forKey: .imageUrls)
        }

        let vrImageUrlsData = try JSONEncoder().encode(vrImageUrls)
        if let vrImageUrlsString = String(data: vrImageUrlsData, encoding: .utf8) {
            try container.encode(vrImageUrlsString, forKey: .vrImageUrls)
        }

        let transactionHistoryData = try JSONEncoder().encode(transactionHistory)
        if let transactionHistoryString = String(data: transactionHistoryData, encoding: .utf8) {
            try container.encode(transactionHistoryString, forKey: .transactionHistory)
        }

        try container.encode(agent.id, forKey: .agent)
        try container.encodeIfPresent(propertyType, forKey: .propertyType)
        let amenitiesData = try JSONEncoder().encode(amenities)
        if let amenitiesString = String(data: amenitiesData, encoding: .utf8) {
            try container.encode(amenitiesString, forKey: .amenities)
        }

        try container.encodeIfPresent(contractType, forKey: .contractType)
        try container.encode(isActive, forKey: .isActive)
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

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let newDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        try container.encode(formatter.string(from: newDate), forKey: .date)
        try container.encode(price, forKey: .price)
    }
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
