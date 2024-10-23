//
//  Chat.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

class InboxViewModel: ObservableObject {
  @Published var chats: [Chat] = []
  var currentUserId: String = "10530025-4005-4c89-b814-b0ea9e389343"

  init() {
    Task {
      await fetchChats()
    }
  }

  func fetchChats() async {
    do {
      let fetchedChats = try await getChats()
      DispatchQueue.main.async {
        self.chats = fetchedChats
      }
    } catch {
      print("Error fetching chats data: \(error)")
    }
  }

  func getChats() async throws -> [Chat] {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    guard let url = URL(string: "https://chat-server.home-nas.xyz/messages/chat/\(currentUserId)")
    else {
      throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw URLError(.badServerResponse)
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(df)
    return try decoder.decode([Chat].self, from: data)
  }
}
