//
//  AgentViewModel.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import Foundation

class AgentViewModel: ObservableObject {
    private let apiClient: APIClient
    @Published var agents: [User] = []
    init(apiClient: APIClient = NetworkManager.shared) {
        self.apiClient = apiClient
        initTask()
    }

    func initTask() {
        Task {
            await fetchAgents()
        }
    }
    
    func fetchAgents() async {
        do {
            let fetchedAgents: [User] = try await apiClient.get(url: "/users/agents")
            DispatchQueue.main.async {
                self.agents = fetchedAgents
            }
        } catch {
            print("Error fetching agents data: \(error)")
        }
    }

    func fetchReview(for agent: User) async {
        do {
            let reviews: [Review] = try await apiClient.get(url: "/reviews/user/\(agent.id)")
            DispatchQueue.main.async {
                if let index = self.agents.firstIndex(where: { $0.id == agent.id }) {
                    self.agents[index].reviews = reviews
                }
            }
        } catch {
            print("Error fetching reviews for agent: \(error)")
        }
    }

    func writeReview(review: Review, reviewedUserId: UUID) async {
        do {
            let postBody: [String: String] = [
                "authorId": review.author.id.uuidString.lowercased(),
                "content": review.content,
                "reviewedUserId": reviewedUserId.uuidString.lowercased(),
                "rating": String(review.rating),
            ]
            print("[DEBUG] Post body: \(postBody)")
            let newReview: Review = try await apiClient.post(url: "/reviews", body: postBody)
            // Update the local data
            DispatchQueue.main.async {
                if let index = self.agents.firstIndex(where: { $0.id == reviewedUserId }) {
                    self.agents[index].reviews.append(newReview)
                }
            }
        } catch {
            print("Error writing review: \(error)")
        }
    }
}
