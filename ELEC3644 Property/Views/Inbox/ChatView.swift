//
//  ChatView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//

import SwiftUI

struct ChatView: View {
    var chat: Chat
    @Environment(\.dismiss) private var dismiss
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            Spacer()
            ForEach(chat.data) { message in
                ChatBubble(message: message)
            }
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
                Button("Back") {
                    dismiss()
                }.foregroundColor(.primary60)
            }
        }
    }
}

struct ChatBubble: View {
    var message: Message
    var isUser: Bool

    init(message: Message) {
        self.message = message
        self.isUser = message.sender == "Me"
    }

    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading) {
            Text("\(message.datetime!.formatted(.dateTime.hour().minute()))").font(.caption)

            Text("\(message.msg)")
                .padding(12)
                .background(isUser ? .primary60 : .neutral40)
                .foregroundColor(isUser ? .neutral10 : .neutral100)
                .cornerRadius(36)
                .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
        }
    }
}

#Preview {
    ChatView(chat: Inbox().chats.first!)
}
