//
//  ChatView.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 15/10/2024.
//
import SwiftUI
import Translation

struct ChatView: View {
    @ObservedObject var chat: Chat
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var newMessage: String = ""
    @StateObject private var webSocketService: WebSocketService
    @State private var isSearchBarVisible: Bool = false
    @State private var searchText: String = ""
    var initialMessage: String?
    @FocusState var foc: Bool?

    init(chat: Chat, initialMessage: String? = nil) {
        self.chat = chat
        _webSocketService = StateObject(
            wrappedValue: WebSocketService(chat: chat))
        self.initialMessage = initialMessage
    }

    var body: some View {
        VStack {
            if groupedMessages.isEmpty && !chat.messages.isEmpty {
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .padding()
                Text("No messages found")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(4)
                Text("Try searching for something else.")
                    .font(.footnote)
                    .foregroundColor(.neutral60)
                    .padding(4)
                Spacer()
            } else {
                ScrollView {
                    Spacer()
                    ForEach(groupedMessages, id: \.key) { date, messages in
                        DateHeader(date: date)
                        ForEach(messages) { message in
                            ChatBubble(
                                message: message,
                                isUser: message.senderId == userViewModel.currentUserId()
                            )
                            .transition(.opacity)
                        }
                    }
                }
                .defaultScrollAnchor(.bottom)
                .scrollIndicators(.hidden)
                .animation(.default, value: searchText)
            }
            HStack(alignment: .bottom) {
                TextField("Type a message...", text: $newMessage, axis: .vertical).focused(
                    $foc, equals: true
                )
                .lineLimit(4)
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
            }.padding((foc ?? false) ? .vertical : .top, 24)
        }
        .onTapGesture {
            foc = nil
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
            if !isSearchBarVisible {
                ToolbarItem(placement: .principal) {
                    Text(chat.user.name)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(SearchTextFieldStyle())
                        .frame(width: isSearchBarVisible ? 300 : 0)
                        .opacity(isSearchBarVisible ? 1 : 0)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSearchBarVisible.toggle()
                        }
                        searchText = ""
                    }) {
                        if isSearchBarVisible {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(8)
                                .foregroundColor(.black)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .addShadow()
                        } else {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.newMessage = initialMessage ?? ""
            webSocketService.connect(userId: userViewModel.currentUserId())
        }
        .onDisappear {
            webSocketService.disconnect()
        }
    }

    private var groupedMessages: [(key: Date, value: [Message])] {
        let filteredMessages = chat.messages.filter { message in
            searchText.isEmpty || message.content.localizedCaseInsensitiveContains(searchText)
        }
        return Dictionary(grouping: filteredMessages) { message in
            Calendar.current.startOfDay(for: message.timestamp)
        }
        .sorted { $0.key < $1.key }
    }

    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let rawMessage =
            "{\"type\": \"sendMessageToUser\",\"content\": \"\(newMessage)\",\"receiverId\": \"\(chat.user.id.uuidString.lowercased())\",\"receiverEmail\": \"\(chat.user.email)\"}"
        webSocketService.sendMessage(message: nil, rawMessage: rawMessage)
        newMessage = ""
    }
}

private func formattedDate(_ date: Date) -> String {
    let calendar = Calendar.current
    if calendar.isDateInToday(date) {
        return "Today"
    } else if calendar.isDateInYesterday(date) {
        return "Yesterday"
    } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        return dateFormatter.string(from: date)
    }
}

struct DateHeader: View {
    let date: Date
    var body: some View {
        Text(formattedDate(date))
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.vertical, 8)
    }
}

struct ChatBubble: View {
    var message: Message
    var isUser: Bool
    @State private var showTranslation: Bool = false
    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading) {
            Text("\(message.content)")
            Text("\(message.timestamp.formatted(.dateTime.hour().minute()))").font(.caption)
        }
        .padding(12)
        .background(isUser ? .primary60 : .neutral40)
        .foregroundColor(isUser ? .neutral10 : .neutral100)
        .cornerRadius(12)
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = message.content
            }) {
                Text("Copy")
                Image(systemName: "doc.on.doc")
            }
            Button(action: {
                showTranslation.toggle()
            }) {
                Text("Translate")
                Image(systemName: "globe")
            }
        }
        .translationPresentation(isPresented: $showTranslation, text: message.content)
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }
}

#Preview {
    ChatView(chat: Mock.Chats.first!)
        .environmentObject(UserViewModel())
}
