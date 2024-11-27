//
//  CreateWishlistForm.swift
//  ELEC3644 Property
//
//  Created by Abel Haris Harsono on 20/11/2024.
//

import SwiftUI

struct CreateWishlistForm: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss

    @State var folderName = "Default"
    @Binding var showSheet: Bool

    let TEXT_LIMIT = 50
    let property: Property

    var body: some View {
        NavigationStack {
            VStack {
                Text(LocalizedStringKey("Name"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.neutral100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)

                TextField("Name", text: $folderName)
                    .textFieldStyle(LoginTextFieldStyle())
                    .multilineTextAlignment(.leading)

                Text(
                    "\(folderName.replacingOccurrences(of: " ", with: "").count)/\(TEXT_LIMIT) characters"
                )
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.neutral70)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .padding(.vertical)

                HStack {
                    Button {
                        folderName = ""
                    } label: {
                        Text("Clear")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral100)
                            .underline()
                    }

                    Spacer()

                    Button {
                        Task {
                            await userViewModel.postWishlist(
                                property: property, folderName: folderName)
                            await userViewModel.fetchWishlist()
                        }
                        showSheet = false
                        dismiss()
                    } label: {
                        Text("Create")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.neutral100)
                            .cornerRadius(10)
                    }
                    .foregroundStyle(.white)
                    .background(
                        folderName.replacingOccurrences(of: " ", with: "").isEmpty
                            ? .gray : .neutral100
                    )
                    .clipShape(.buttonBorder)
                    .disabled(folderName.replacingOccurrences(of: " ", with: "").isEmpty)
                }
            }
            .navigationTitle("Create wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.neutral100)
                    }
                }
            }
            .padding()
        }
        .onChange(of: folderName) { oldValue, newValue in
            if newValue.replacingOccurrences(of: " ", with: "").count > TEXT_LIMIT {
                folderName = oldValue
            }
        }
    }
}

#Preview {
    CreateWishlistForm(showSheet: .constant(true), property: Mock.Properties[0]).environmentObject(
        UserViewModel())
}
