import PhotosUI
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
    @State private var isImagePickerPresented: Bool = false
    @State private var isCamera: Bool = false
    @State var selectedItems: [PhotosPickerItem] = []

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
                    .foregroundColor(.neutral70)
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
                            .frame(
                                maxWidth: UIScreen.main.bounds.width * 0.75,
                                maxHeight: UIScreen.main.bounds.height * 0.4
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: message.senderId == userViewModel.currentUserId()
                                    ? .trailing : .leading
                            )
                            .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal)
                .defaultScrollAnchor(.bottom)
                .scrollIndicators(.hidden)
                .animation(.default, value: searchText)
            }
            HStack {
                HStack(spacing: 18) {
                    TextField("", text: $newMessage, axis: .vertical)
                        .focused(
                            $foc, equals: true
                        )
                        .lineLimit(4)
                        .frame(minHeight: 30)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.neutral40)
                        .foregroundColor(.neutral100)
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 1,
                        matching: .images
                    ) {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.semibold)
                            .frame(width: 18, height: 18)
                    }
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.semibold)
                            .frame(width: 18, height: 18)
                    }
                }
                .padding(.horizontal, 18)
                .padding((foc ?? false) ? .vertical : .top, 12)
            }
            .background(.neutral30)
        }
        .onTapGesture {
            foc = nil
        }
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
                if !chat.user.phone.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            UIApplication.shared.open(
                                URL(string: "tel://\(chat.user.phone)")!)
                        }) {
                            Image(systemName: "phone")
                        }
                    }
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
                                .foregroundColor(.neutral100)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .addShadow()
                        } else {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.neutral100)
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
        .onChange(
            of: selectedItems
        ) { _, newValue in
            Task {
                if let data = try? await newValue[0].loadTransferable(type: Data.self) {
                    let res: Data = try await NetworkManager.shared.uploadImage(
                        imageData: data)
                    let json = try JSONSerialization.jsonObject(with: res, options: [])
                    if let json = json as? [String: Any],
                        let imageUrl = json["url"] as? String
                    {
                        newMessage = imageUrl
                        sendMessage()
                    }
                }
            }
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
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
    }
}

struct ChatBubble: View {
    var message: Message
    var isUser: Bool
    @State private var showTranslation: Bool = false
    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading) {
            if message.content.hasPrefix("https://chat-server.home-nas.xyz/images/") {
                AsyncImage(url: URL(string: message.content)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            } else {
                Text("\(message.content)")
            }
            VStack(alignment: .trailing) {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))").font(.caption)
            }
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
