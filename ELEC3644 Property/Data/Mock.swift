//
//  Mock.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 24/10/24.
//

import Foundation

enum Mock{
    static var Properties: [Property] = [
        Property(
            name: "The Pavilia Hill",
            address: "18 Pak Tai Street, Ma On Shan",
            area: "Ma On Shan",
            district: "Sha Tin",
            subDistrict: "Ma On Shan",
            facilities: [
                Facility(desc: "Swimming Pool", measure: 1, measureUnit: "unit"),
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
                Transaction(date: Date(), price: 7500000)
            ]
        ),
    ]
}
