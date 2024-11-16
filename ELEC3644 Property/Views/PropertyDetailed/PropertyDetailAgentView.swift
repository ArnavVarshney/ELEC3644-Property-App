//
//  PropertyDetailAgentView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 16/11/24.
//

import SwiftUI

struct PropertyDetailAgentView: View {
    @StateObject var viewModel: PropertyDetailViewModel
    @EnvironmentObject var inboxData: InboxViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()

            Text("Agent")
                .font(.system(size: 24, weight: .medium))

            HStack {
                UserAvatarView(user: viewModel.property.agent, size: 64)
                    .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    Text(viewModel.property.agent.name)
                        .font(.system(size: 16, weight: .bold))
                    Text("Tel: \(viewModel.property.agent.phone)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.neutral60)
                }
            }

            HStack {
                Button(
                    action: {
                        UIApplication.shared.open(
                            URL(string: "tel://\(viewModel.property.agent.phone)")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "phone")
                            Text("Call")
                        }
                        .frame(maxWidth: .infinity)
                    })

                Divider()
                    .frame(height: 24)

                NavigationLink(
                    destination: ChatView(chat: chat()),
                    label: {
                        HStack {
                            Image(systemName: "message")
                            Text("Message")
                        }
                        .frame(maxWidth: .infinity)
                    })
            }
            .foregroundColor(.black)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .toolbar(.hidden, for: .tabBar)
    }

    private func chat() -> Chat {
        for chat in inboxData.chats {
            if chat.user.id == viewModel.property.agent.id {
                return chat
            }
        }
        return Chat(user: viewModel.property.agent, messages: [])
    }
}

#Preview {
    struct PropertyDetailAgentView_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            PropertyDetailAgentView(
                viewModel: PropertyDetailViewModel(property: Mock.Properties[0]))
        }
    }
    return PropertyDetailAgentView_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(InboxViewModel())
}
