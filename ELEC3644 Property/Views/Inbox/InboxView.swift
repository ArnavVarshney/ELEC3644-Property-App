//
//  InboxView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//
import SwiftUI

struct InboxView: View {
    @EnvironmentObject var inboxData: InboxViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        NavigationStack {
            VStack {
                if inboxData.chats.isEmpty {
                    Image(systemName: "bubble.left.and.text.bubble.right")
                        .font(.largeTitle)
                        .padding()
                    Text("You don't have any messages")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(4)
                    Text("When you receive a new message, it will appear here.")
                        .font(.footnote)
                        .foregroundColor(.neutral60)
                        .padding(4)
                } else {
                    List(inboxData.chats) { chat in
                        NavigationLink {
                            ChatView(chat: chat)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            InboxItemView(user: chat.user, message: chat.messages.last!)
                        }
                    }
                    .listStyle(InsetListStyle())
                }
            }
            .background(.neutral10)
            .navigationTitle("Messages")
        }
    }
}

#Preview {
    InboxView()
        .environmentObject(InboxViewModel(chats: Mock.Chats))
        .environmentObject(UserViewModel())
}
