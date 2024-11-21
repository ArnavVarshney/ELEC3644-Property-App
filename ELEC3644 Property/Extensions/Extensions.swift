//
//  Extensions.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 11/10/2024.
//
import AVKit
import SwiftUI

struct BackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            self.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .frame(width: 18, height: 18)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                        }
                    }
                }
            }
    }
}

struct AddShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
    }
}

extension View {
    func backButton() -> some View {
        modifier(BackButtonModifier())
    }

    func addShadow() -> some View {
        modifier(AddShadow())
    }
}

extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        showsPlaybackControls = false
        videoGravity = .resizeAspect
    }
}

extension Int {
    func toCurrencyFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "en_HK")
        return numberFormatter.string(from: NSNumber(value: self))!
    }

    func toCompactCurrencyFormat() -> String {
        return "HK$ \(formatted(.number.notation(.compactName)))"
    }

    func toCompactFormat() -> String {
        return formatted(.number.notation(.compactName))
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    NavigationStack {
        VStack {
            Text("Hello")
            Spacer()
        }
        .backButton()
        .navigationTitle("Test")
    }
}
