//
//  InboxViewModel.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//
import Foundation

class InboxViewModel: ObservableObject {
    private let apiClient: APIClient
    private let userViewModel = UserViewModel.shared
    @Published var chats: [Chat] = []
    init(apiClient: APIClient = NetworkManager(), chats: [Chat] = []) {
        self.chats = chats
        self.apiClient = apiClient
        if chats.isEmpty {
            Task {
                await fetchChats()
            }
        }
    }

    func fetchChats() async {
        do {
            let fetchedChats: [Chat] = try await apiClient.get(
                url: "/messages/chat/\(userViewModel.currentUserId())")
            DispatchQueue.main.async {
                self.chats = fetchedChats
            }
        } catch {
            print("Error fetching chats data: \(error)")
        }
    }
}
