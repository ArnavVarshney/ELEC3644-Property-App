//
//  Chat.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

class Inbox: ObservableObject {
    @Published var chats: [Chat] = []

    init() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let pathString = Bundle.main.path(forResource: "inbox", ofType: "json")

        if let path = pathString {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(df)
                do {
                    let decoded = try decoder.decode([Chat].self, from: data)
                    self.chats = decoded
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
        }
    }
}
