//
//  SchoolNet.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import Foundation

struct SchoolNet: Identifiable, Hashable {
    let id = UUID()
    let primary: String
    let secondary: String
}
