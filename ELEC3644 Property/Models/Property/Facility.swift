//
//  Facility.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

struct Facility: Identifiable, Hashable, Decodable {
    var id = UUID()
    let desc: String
    let measure: Int
    let measureUnit: String
}
