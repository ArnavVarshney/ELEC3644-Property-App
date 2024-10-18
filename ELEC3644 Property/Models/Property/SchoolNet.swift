//
//  SchoolNet.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

struct SchoolNet: Identifiable, Hashable, Codable {
    var id = UUID()
    let primary: String
    let secondary: String

    private enum CodingKeys: String, CodingKey { case primary, secondary }
}
