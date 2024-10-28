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

class Chat: Identifiable, Codable, ObservableObject {
    var id = UUID()
    let user: User
    @Published var messages: [Message]

    private enum CodingKeys: String, CodingKey { case user, messages }

    init(user: User, messages: [Message]) {
        self.user = user
        self.messages = messages
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(User.self, forKey: .user)
        messages = try container.decode([Message].self, forKey: .messages)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
        try container.encode(messages, forKey: .messages)
    }
}
