//
//  ChatView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import SwiftUI

struct ChatView: View {
  var chat: Chat
  var currentUserId: String
  @Environment(\.dismiss) private var dismiss
  @State private var newMessage: String = ""

  var body: some View {
    VStack {
      ScrollView {
        Spacer()
        ForEach(chat.messages) { message in
          ChatBubble(message: message, isUser: message.senderId == currentUserId)
        }
      }.defaultScrollAnchor(.bottom)

      HStack {
        TextField("Type a message...", text: $newMessage)
          .frame(minHeight: 30)
          .padding(12)
          .background(.neutral30)
          .foregroundColor(.neutral100)
          .cornerRadius(36)
          .frame(maxWidth: .infinity)
        Image(systemName: "paperplane")
          .resizable()
          .scaledToFit()
          .frame(width: 18, height: 18)
          .padding(18)
          .background(.neutral30)
          .cornerRadius(36)
      }.padding(.top, 24)
    }
    .padding(.horizontal, 24)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: {
          dismiss()
        }) {
          Image(systemName: "chevron.left")
        }
      }
      ToolbarItem(placement: .principal) {
        Text(chat.user.name)
          .font(.headline)
          .fontWeight(.bold)
      }
    }
  }
}

struct ChatBubble: View {
  var message: Message
  var isUser: Bool

  var body: some View {
    VStack(alignment: isUser ? .trailing : .leading) {
      Text("\(message.content)")
      Text("\(message.timestamp.formatted(.dateTime.hour().minute()))").font(.caption)
    }
    .padding(12)
    .background(isUser ? .primary60 : .neutral40)
    .foregroundColor(isUser ? .neutral10 : .neutral100)
    .cornerRadius(12)
    .frame(width: 300)
    .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
  }
}

#Preview {
  struct ChatView_Preview: View {
    @EnvironmentObject var inboxData: InboxViewModel
    var body: some View {
      NavigationView {
        if inboxData.chats.first == nil {
          Text("Loading...")
        } else {
          ChatView(
            chat: inboxData.chats.first!, currentUserId: inboxData.currentUserId)
        }
      }
    }
  }
  return ChatView_Preview()
    .environmentObject(InboxViewModel())
}
