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
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.neutral100)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
    }
}

struct AddShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 4)
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

extension String {
    func toPhoneNumberFormat() -> String {
        let cleaned = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+XXX XXXX XXXX"
        var result = ""
        var index = cleaned.startIndex
        for ch in mask where index < cleaned.endIndex {
            if ch == "X" {
                result.append(cleaned[index])
                index = cleaned.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
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

extension User {
    func firstName() -> String {
        if name.split(separator: " ").count > 1 {
            return String(name.split(separator: " ")[0])
        } else {
            return name
        }
    }
}

extension [Property] {
    func getTransactions() -> [PropertyTransaction] {
        var transactions: [PropertyTransaction] = []
        for property in self {
            transactions.append(contentsOf: property.getTransactions())
        }
        transactions.sort { $0.transaction.date > $1.transaction.date }
        return transactions
    }
}

extension Property {
    func getTransactions() -> [PropertyTransaction] {
        var transactions: [PropertyTransaction] = []
        for (idx, transaction) in self.transactionHistory.enumerated() {
            let propertyTransaction = PropertyTransaction(
                transaction: transaction, property: self,
                priceDelta: idx == 0
                    ? 0 : transaction.price - self.transactionHistory[idx - 1].price
            )
            transactions.append(propertyTransaction)
        }
        return transactions
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
