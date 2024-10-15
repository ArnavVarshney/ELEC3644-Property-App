//
//  Chat.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

struct Chat: Identifiable, Decodable{
    let id: Int
    let name: String
    var data: [Message]
}

