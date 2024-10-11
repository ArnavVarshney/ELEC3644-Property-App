//
//  MenuItem.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import Foundation

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
}
