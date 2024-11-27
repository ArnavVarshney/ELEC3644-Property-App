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
        VStack(alignment: .leading) {
            HStack {
                Text("\(agentViewModel.agents.count)")
                    .fontWeight(.bold)
                    .font(.subheadline)
                Text("agents found")
                    .font(.subheadline)
            }
            .padding(.horizontal, 24)
            Divider()
                .clipped()
            List(agentViewModel.agents) { agent in
                NavigationLink {
                    ProfileDetailedView(user: agent)
                } label: {
                    AgentItemView(user: agent)
                }
            }
            .listStyle(InsetListStyle())
            .refreshable {
                agentViewModel.initTask()
            }
        }
        .padding(.top, 12)
    }
}

struct AgentItemView: View {
    let user: User
    var body: some View {
        HStack {
            UserAvatarView(user: user, size: 72)
                .padding(.trailing, 4)
                .padding(.leading, -8)
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(user.phone.toPhoneNumberFormat())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.neutral70)
                Text(user.email)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.neutral70)
                HStack(alignment: .center) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.neutral100)
                            .padding(-3)
                            .opacity(index < Int(UserViewModel.averageRating(for: user)) ? 1 : 0.3)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 4)
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
