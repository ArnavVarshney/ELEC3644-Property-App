//
//  InboxView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//
import SwiftUI

struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.footnote)
            .padding(8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color.black.opacity(0.7), lineWidth: 1)
            )
    }
}

struct InboxView: View {
    @EnvironmentObject var inboxData: InboxViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isSearchBarVisible: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                if userViewModel.isLoggedIn() {
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
                        if inboxData.filteredChats(searchText: searchText).isEmpty {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .padding()
                            Text("No chats found")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .padding(4)
                            Text("Try searching for something else.")
                                .font(.footnote)
                                .foregroundColor(.neutral60)
                                .padding(4)
                        } else {
                            List(inboxData.filteredChats(searchText: searchText)) { chat in
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
                } else {
                    VStack(alignment: .leading) {
                        Text("Log in to see messages")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)
                        Text("Once you login, you'll find messages here.")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                            .padding(.trailing, 8)
                        LoginButton()
                        Spacer()
                    }
                    .padding(.horizontal, 32)
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
