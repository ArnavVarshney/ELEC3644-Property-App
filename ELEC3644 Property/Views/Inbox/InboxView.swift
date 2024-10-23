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
    VStack {
      VStack {
        HStack {
          Spacer()
          Button {
            print(inboxData.chats)
          } label: {
            Text("Search")
          }

          Button {
          } label: {
            Text("Setting")
          }

        }.foregroundColor(.neutral100)

        HStack {
          Text("Messages")
          Spacer()
        }

        HStack {
          Button {
          } label: {
            Text("All")
          }

          Button {
          } label: {
            Text("Hosting")
          }

          Button {
          } label: {
            Text("Travelling")
          }

          Button {
          } label: {
            Text("Support")
          }

          Spacer()
        }.foregroundColor(.neutral100)
      }
      if inboxData.chats.isEmpty {
        Text("Nothing to show...")
      } else {
        List(inboxData.chats) { chat in
          NavigationLink {
            ChatView(chat: chat, currentUserId: inboxData.currentUserId)
          } label: {
            InboxItemView(name: chat.userId, date: chat.messages.last!.dateStr)
          }
        }
      }
    }
    .padding( /*@START_MENU_TOKEN@*/.all /*@END_MENU_TOKEN@*/)
    .navigationTitle("Inbox")
  }
}

#Preview {
  InboxView()
    .environmentObject(InboxViewModel())
}
