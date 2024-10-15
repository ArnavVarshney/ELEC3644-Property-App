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
    var body: some View {
        VStack{
            ForEach(chat.data){message in
                Text(message.msg)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading ){
                Button("Back"){
                    dismiss()
                }.foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    ChatView(chat: Inbox().chats.first!)
}
