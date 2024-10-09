//
//  Tag.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    let id = UUID()
    let label: String
    var content: String?
}
