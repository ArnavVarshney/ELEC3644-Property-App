//
//  Message.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

struct Message: Identifiable, Decodable {
    let id: Int
    let datetime: Date?
    let sender: String
    let msg: String
    var dateStr: String {
        if let d = datetime {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df.string(from: d)
        } else {
            return "None"
        }
    }
}
