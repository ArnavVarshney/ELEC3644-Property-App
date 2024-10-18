//
//  Chat.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

struct Chat: Identifiable, Codable {
    var id = UUID()
    let name: String
    var data: [Message]

    private enum CodingKeys: String, CodingKey { case name, data }
}
