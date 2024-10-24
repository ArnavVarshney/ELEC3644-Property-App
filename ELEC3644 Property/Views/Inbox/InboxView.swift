//
//  InboxView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import SwiftUI

struct InboxView: View {
  @EnvironmentObject var inboxData: InboxViewModel

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
              ChatView(chat: chat, currentUserId: inboxData.currentUserId)
            } label: {
              InboxItemView(name: chat.user.name, date: chat.messages.last!.timestamp)
            }
          }
        }
      }
      .background(.neutral10)
      .padding(.all)
      .navigationTitle("Messages")
    }
  }
}

#Preview {
  InboxView()
    .environmentObject(InboxViewModel())
}
