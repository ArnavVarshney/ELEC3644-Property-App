//
//  Chat.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import Foundation

class InboxViewModel: ObservableObject {
  private let apiClient: APIClient
  private let webSocketClient: WebSocketService
  @Published var chats: [Chat] = []
  var currentUserId: String = "10530025-4005-4c89-b814-b0ea9e389343"

  init(
    apiClient: APIClient = NetworkManager(), webSocketClient: WebSocketService = WebSocketService(),
    chats: [Chat] = []
  ) {
    self.chats = chats
    self.apiClient = apiClient
    self.webSocketClient = webSocketClient
    if chats.isEmpty {
      Task {
        await fetchChats()
      }
    }
  }

  func fetchChats() async {
    do {
      let fetchedChats: [Chat] = try await apiClient.get(url: "/messages/chat/\(currentUserId)")
      DispatchQueue.main.async {
        self.chats = fetchedChats
      }
    } catch {
      print("Error fetching chats data: \(error)")
    }
  }
}
