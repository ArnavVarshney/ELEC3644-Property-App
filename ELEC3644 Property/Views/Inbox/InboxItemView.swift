//
//  InboxItemView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//
import SwiftUI

struct InboxItemView: View {
    let user: User
    let message: Message
    var body: some View {
        HStack {
            UserAvatarView(user: user, size: 42)
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                if message.content.hasPrefix("https://chat-server.home-nas.xyz/images/") {
                    Text("📷 Photo")
                        .font(.footnote)
                        .lineLimit(1)
                } else {
                    Text(message.content)
                        .font(.footnote)
                        .lineLimit(1)
                }
            }
            Spacer()
            Text(message.timestamp, style: .time)
                .font(.caption)
                .foregroundColor(.neutral70)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    InboxItemView(user: Mock.Chats[0].user, message: Mock.Chats[0].messages.last!)
}
