//
//  Message.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

struct Message: Identifiable, Codable {
    var id = UUID()
    let timestamp: Date?
    let sender: String
    let receiver: String
    let content: String
    var dateStr: String {
        if let d = timestamp {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df.string(from: d)
        } else {
            return "None"
        }
    }

    private enum CodingKeys: String, CodingKey { case timestamp, sender, receiver, content }
}
