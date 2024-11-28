//
//  PropertyDetailBottomBarView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import SwiftUI

struct PropertyDetailBottomBarView: View {
    @StateObject var viewModel: PropertyDetailViewModel
    @EnvironmentObject var inboxData: InboxViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var showPriceInputAlert = false
    @State var sellPrice = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("$\(viewModel.property.netPrice) HKD")
                    .font(.system(size: 16, weight: .bold))
                Text("20 year installments")
                    .font(.system(size: 14, weight: .regular))
            }
            Spacer()
            if userViewModel.userRole == .guest {
                NavigationLink(
                    destination: ChatView(
                        chat: chat(),
                        initialMessage:
                            "Hi, I'm interested in \(viewModel.property.name). Can you provide more details?"
                    ),
                    label: {
                        Text("Request")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.neutral100)
                            .cornerRadius(10)
                    }
                )
            } else if userViewModel.user.id == viewModel.property.agent.id
                && viewModel.property.isActive
            {
                Button {
                    showPriceInputAlert = true
                } label: {
                    Text("Mark as Sold")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.neutral100)
                        .cornerRadius(10)
                }
                .alert("Property Sold", isPresented: $showPriceInputAlert) {
                    TextField("Price", text: $sellPrice)
                    Button("Save") {
                        Task {
                            do {
                                viewModel.property.transactionHistory.append(
                                    Transaction(date: Date.now, price: Int(sellPrice)!))
                                let _: Property = try await NetworkManager.shared.patch(
                                    url:
                                        "/properties/\(viewModel.property.id.uuidString.lowercased())",
                                    body: [
                                        "transactionHistory": viewModel.property.transactionHistory
                                    ])
                            } catch {
                                print(error)
                            }
                        }
                        Task {
                            do {
                                let _: Property = try await NetworkManager.shared.patch(
                                    url:
                                        "/properties/\(viewModel.property.id.uuidString.lowercased())",
                                    body: ["isActive": false])
                            } catch {
                                print(error)
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("How much did you sell/rent/lease this property for?")
                }
            } else if userViewModel.user.id == viewModel.property.agent.id {
                Button {
                } label: {
                    Text("Sold")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.neutral70)
                        .cornerRadius(10)
                }
                .disabled(true)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }

    private func chat() -> Chat {
        for chat in inboxData.chats {
            if chat.user.id == viewModel.property.agent.id {
                return chat
            }
        }
        return Chat(user: viewModel.property.agent, messages: [])
    }
}

#Preview {
    struct PropertyDetailBottomBar_Preview: View {
        @EnvironmentObject var viewModel: PropertyViewModel
        var body: some View {
            PropertyDetailBottomBarView(
                viewModel: PropertyDetailViewModel(property: Mock.Properties[0]))
        }
    }
    return PropertyDetailBottomBar_Preview()
        .environmentObject(PropertyViewModel())
        .environmentObject(InboxViewModel())
}
