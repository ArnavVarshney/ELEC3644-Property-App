//
//  PropertyDetailBottomBarView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import SwiftUI

struct PropertyDetailBottomBarView: View {
    @StateObject var viewModel: PropertyDetailViewModel
    @EnvironmentObject var inboxData: InboxViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("$\(viewModel.property.netPrice) HKD")
                    .font(.system(size: 16, weight: .bold))
                Text("20 year installments")
                    .font(.system(size: 14, weight: .regular))
            }
            Spacer()
            NavigationLink(
                destination: ChatView(
                    chat: chat(), currentUserId: userViewModel.currentUserId,
                    initialMessage:
                        "Hi, I'm interested in \(viewModel.property.name). Can you provide more details?"
                ),
                label: {
                    Text("Request")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.neutral10)
                        .padding()
                        .background(Color.primary60)
                        .cornerRadius(10)
                })
        }
        .padding()
        .background(Color(.systemGray6))
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
    struct PropertyDetailBottomBar_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            PropertyDetailBottomBarView(
                viewModel: PropertyDetailViewModel(property: Mock.Properties[0]))
        }
    }
    return PropertyDetailBottomBar_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(InboxViewModel())
}
