//
//  Message.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

struct Message: Identifiable, Codable {
  var id = UUID()
  let timestamp: Date
  let senderId: String
  let receiverId: String
  let content: String

  private enum CodingKeys: String, CodingKey { case timestamp, senderId, receiverId, content }
}

struct Chat: Identifiable, Codable {
  var id = UUID()
  let user: User
  var messages: [Message]

  private enum CodingKeys: String, CodingKey { case user, messages }
}
