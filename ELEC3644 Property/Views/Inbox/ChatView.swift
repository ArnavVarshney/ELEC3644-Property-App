//
//  ChatView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import SwiftUI

struct ChatView: View {
  @ObservedObject var chat: Chat
  var currentUserId: String

  @Environment(\.dismiss) private var dismiss
  @State private var newMessage: String = ""
  @StateObject private var webSocketService: WebSocketService

  init(chat: Chat, currentUserId: String) {
    self.chat = chat
    self.currentUserId = currentUserId
    _webSocketService = StateObject(
      wrappedValue: WebSocketService(userId: currentUserId, chat: chat))
  }

  var body: some View {
    VStack {
      ScrollView {
        Spacer()
        ForEach(chat.messages) { message in
          ChatBubble(message: message, isUser: message.senderId == currentUserId)
        }
      }.defaultScrollAnchor(.bottom)
        .scrollIndicators(.hidden)

      HStack {
        TextField("Type a message...", text: $newMessage)
          .frame(minHeight: 30)
          .padding(12)
          .background(.neutral30)
          .foregroundColor(.neutral100)
          .cornerRadius(36)
          .frame(maxWidth: .infinity)

        Button(action: sendMessage) {
          Image(systemName: "paperplane")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .padding(18)
            .background(.neutral30)
            .cornerRadius(36)
        }
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

  private func sendMessage() {
    guard !newMessage.isEmpty else { return }
    let rawMessage =
      "{\"type\": \"sendMessageToUser\",\"content\": \"\(newMessage)\",\"receiverId\": \"\(chat.user.id.uuidString.lowercased())\",\"receiverEmail\": \"\(chat.user.email)\"}"
    webSocketService.sendMessage(message: nil, rawMessage: rawMessage)
    newMessage = ""
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
    .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
  }
}

#Preview {
  ChatView(chat: Mock.Chats.first!, currentUserId: "\(Mock.Chats.first!.user.id)")
}
