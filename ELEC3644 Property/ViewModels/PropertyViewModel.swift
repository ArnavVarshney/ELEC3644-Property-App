//
//  PropertyViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

class PropertyViewModel: ObservableObject {
    @Published var properties: [Property] = [
        Property(name: "Grandview Garden - 1E",
                 address: "8 Nam Long Shan Road",
                 area: "HK Island",
                 district: "Central and Western",
                 subDistrict: "Sheung Wan",
                 facilities: [
                     Facility(desc: "mtr", measure: 8, measureUnit: "min(s)")
                 ],
                 schoolNet: SchoolNet(
                     primary: "11",
                     secondary: "Central and Western District"
                 ),
                 saleableArea: 305,
                 saleableAreaPricePerSquareFoot: 14262,
                 grossFloorArea: 417,
                 grossFloorAreaPricePerSquareFoot: 10432,
                 netPrice: "7.4m",
                 buildingAge: 39,
                 buildingDirection: "South East",
                 estate: "Grandview Garden",
                 transactionHistory: [
                     Transaction(date: Date(timeIntervalSince1970: 1609459200), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1612137600), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1614556800), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1617235200), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1619827200), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1622505600), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1625097600), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1627776000), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1630454400), price: Int.random(in: 6000000...8500000)),
                     Transaction(date: Date(timeIntervalSince1970: 1633046400), price: Int.random(in: 6000000...8500000))
                 ])
    ]
}
