//
//  WebSocketService.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 27/10/2024.
//

import Foundation
import SwiftUI

class WebSocketService: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    var chat: Chat
    var userId: String

    init(userId: String, chat: Chat) {
        self.chat = chat
        self.userId = userId
//        connect(userId: userId)
    }

    func connect(userId: String) {
        guard let url = URL(string: "wss://chat-server.home-nas.xyz/") else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        receiveMessages()
        let rawMessage = "{\"type\": \"setUser\", \"userId\": \"\(userId)\"}"
        webSocketTask?.resume()
        sendMessage(message: nil, rawMessage: rawMessage)
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    func sendMessage(message: Message?, rawMessage: String?) {
        if let message = message {
            let messageData = try? JSONEncoder().encode(message)
            let webSocketMessage = URLSessionWebSocketTask.Message.data(messageData!)
            webSocketTask?.send(webSocketMessage) { error in
                if let error = error {
                    print("WebSocket send error: \(error)")
                }
            }
        } else if let rawMessage = rawMessage {
            print("[DEBUG] Sending raw message...:\(rawMessage)")
            let webSocketMessage = URLSessionWebSocketTask.Message.string(rawMessage)
            webSocketTask?.send(webSocketMessage) { error in
                if let error = error {
                    print("WebSocket send error: \(error)")
                }
            }
        }
    }

    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8),
                        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                        let jsonDict = jsonObject as? [String: Any]
                    {
                        DispatchQueue.main.async {
                            switch jsonDict["type"] as? String {
                            case "newMessage":
                                print("[DEBUG - WS] New Message")
                                print(
                                    "[DEBUG] New Message: [\nType: \(String(describing: jsonDict["type"]))\nSenderID: \(String(describing: jsonDict["senderId"]))\nReceiverID: \(String(describing: jsonDict["receiverId"]))\nContent: \(String(describing: jsonDict["content"]))\n]"
                                )
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                if let timestampString = jsonDict["timestamp"] as? String,
                                    let timestamp = df.date(from: timestampString)
                                {
                                    self?.chat.messages.append(
                                        Message(
                                            id: UUID(uuidString: jsonDict["id"] as! String)!,
                                            timestamp: timestamp,
                                            senderId: jsonDict["senderId"] as! String,
                                            receiverId: jsonDict["receiverId"] as! String,
                                            content: jsonDict["content"] as! String
                                        )
                                    )
                                }
                            case "connected":
                                print("[DEBUG - WS] WebSocket connected")
                                self?.startPingTimer()
                            case "userSet":
                                print("[DEBUG - WS] User set successfully")
                            case "pong":
                                print("[DEBUG - WS] Received pong")
                            default:
                                print(
                                    "[DEBUG - WS] Unknown message type: \(jsonDict["type"] ?? Error.self)"
                                )
                            }
                        }
                    }
                default:
                    break
                }
                self?.receiveMessages()
            }
        }
    }

    private func startPingTimer() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.sendPing()
        }
    }

    private func sendPing() {
        let pingMessage = "{\"type\": \"ping\"}"
        sendMessage(message: nil, rawMessage: pingMessage)
    }

    deinit {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
