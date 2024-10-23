//
//  WebSocketService.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 22/10/2024.
//

import Foundation

class WebSocketService: ObservableObject {
    private var webSocket: URLSessionWebSocketTask?
    @Published var isConnected = false
    var onReceive: ((String) -> Void)?

    func connect() {
        let url = URL(string: "ws://your-server-url")!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: request)
        webSocket?.resume()
        isConnected = true
        receiveMessage()
    }

    func disconnect() {
        webSocket?.cancel(with: .normalClosure, reason: nil)
        isConnected = false
    }

    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.onReceive?(text)
                    }
                default:
                    break
                }
                self?.receiveMessage()
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            }
        }
    }

    func send(_ message: String) {
        webSocket?.send(.string(message)) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
    }
}
