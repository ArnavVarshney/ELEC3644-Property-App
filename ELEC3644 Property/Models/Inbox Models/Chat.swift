//
//  Chat.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

struct Chat: Identifiable, Codable {
  var id = UUID()
  let userId: String
  var messages: [Message]

  private enum CodingKeys: String, CodingKey { case userId, messages }
}
