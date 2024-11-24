//
//  AgentsMenuView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

struct AgentMenuView: View {
    @EnvironmentObject var agentViewModel: AgentViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(agentViewModel.agents) { agent in
                    HStack {
                        UserAvatarView(user: agent, size: 72)
                        VStack(alignment: .leading) {
                            Text(agent.name)
                                .font(.headline)
                            Text(agent.email)
                                .font(.subheadline)
                            HStack {
                                Image(systemName: "star.fill")
                                    .frame(width: 16, height: 16)
                                Text(
                                    "\(UserViewModel.averageRating(for: agent), specifier: "%.2f")")
                            }
                        }
                        Spacer()
                        NavigationLink(destination: ProfileDetailedView(user: agent)) {
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(10)
                                .foregroundColor(.neutral70)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .refreshable {
            agentViewModel.initTask()
        }
    }
}

#Preview {
    struct AgentMenuView_Preview: View {
        @EnvironmentObject var viewModel: AgentViewModel
        var body: some View {
            AgentMenuView()
                .environmentObject(viewModel)
        }
    }
    return AgentMenuView_Preview()
        .environmentObject(AgentViewModel())
}
