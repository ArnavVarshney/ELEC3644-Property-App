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
                VStack(alignment: .leading) {
                    Text(
                        "Name"
                    ).font(.footnote).foregroundStyle(.neutral60).padding(
                        .init(top: 0, leading: 0, bottom: 5, trailing: 0))

                    TextField("", text: $folderName, axis: .vertical).font(.system(size: 15))
                        .multilineTextAlignment(.leading)

                }
                .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(.black)
                }
                .padding(10)

                HStack {
                    Text(
                        "\(folderName.replacingOccurrences(of: " ", with: "").count)/\(TEXT_LIMIT) characters"
                    )
                    .font(.footnote)
                    .foregroundStyle(.neutral60)
                    .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                    Spacer()
                }.padding(.init(top: 0, leading: 10, bottom: 10, trailing: 10))

                Divider()

                HStack {
                    Button {
                        folderName = ""
                    } label: {
                        Text("Clear").underline()
                    }
                    .foregroundStyle(
                        folderName.replacingOccurrences(of: " ", with: "").isEmpty ? .gray : .black
                    )
                    .disabled(folderName.replacingOccurrences(of: " ", with: "").isEmpty)

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
                        Text("Create").bold().padding(
                            .init(top: 15, leading: 20, bottom: 15, trailing: 20))
                    }
                    .foregroundStyle(.white)
                    .background(
                        folderName.replacingOccurrences(of: " ", with: "").isEmpty ? .gray : .black
                    )
                    .clipShape(.buttonBorder)
                    .disabled(folderName.replacingOccurrences(of: " ", with: "").isEmpty)
                }
                .padding()
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }.foregroundStyle(.black)
                }

                ToolbarItem(placement: .principal) {
                    Text("Create wishlist")
                }
            }
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
