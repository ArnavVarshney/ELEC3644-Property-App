//
//  Extensions.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 11/10/2024.
//
import AVKit
import CoreData
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

class AsyncImageViewModel: ObservableObject {
    @Published var uiImage: UIImage? = nil
    private let url: URL
    private let context: NSManagedObjectContext

    init(url: URL, context: NSManagedObjectContext) {
        self.url = url
        self.context = context
        Task {
            await fetchImage()
        }
    }

    @MainActor
    private func fetchImage() async {
        let fetchRequest: NSFetchRequest<CachedImage> = CachedImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url.absoluteString)

        do {
            let results = try context.fetch(fetchRequest)
            if let cachedImage = results.first, let imageData = cachedImage.imageData,
                let image = UIImage(data: imageData)
            {
                self.uiImage = image
            } else {
                await downloadImage()
            }
        } catch {
            print("Failed to fetch image: \(error)")
            await downloadImage()
        }
    }

    @MainActor
    private func downloadImage() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                self.uiImage = image
                saveImageToCoreData(data: data)
            }
        } catch {
            print("Failed to download image: \(error.localizedDescription)")
        }
    }

    private func saveImageToCoreData(data: Data) {
        let cachedImage = CachedImage(context: context)
        cachedImage.url = url.absoluteString
        cachedImage.imageData = data

        do {
            try context.save()
        } catch {
            print("Failed to save image: \(error)")
        }
    }
}

struct AsyncImageView: View {
    @StateObject private var viewModel: AsyncImageViewModel

    init(url: URL, context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AsyncImageViewModel(url: url, context: context))
    }

    var body: some View {
        if let uiImage = viewModel.uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ProgressView()
        }
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
