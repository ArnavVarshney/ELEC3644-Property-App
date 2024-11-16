//
//  PersonalInfo.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 17/11/24.
//

import SwiftUI

struct InfoItem {
    let name: String
    let field: String
    let value: String
    let edit: Bool
}

struct PersonalInfoView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                InfoList(items: [
                    InfoItem(
                        name: "Full name", field: "name", value: userViewModel.user.name, edit: true
                    ),
                    InfoItem(
                        name: "Email", field: "email", value: userViewModel.user.email, edit: false),
                    InfoItem(
                        name: "Phone", field: "phone", value: userViewModel.user.phone, edit: true),
                ])
                .padding(.top, 24)
                Spacer()
            }
            .navigationTitle("Personal Info")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}

struct InfoList: View {
    let items: [InfoItem]
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isEditing: Bool = false
    @State private var editingText: String = ""
    @State private var editingIndex: Int? = nil

    var body: some View {
        LazyVStack {
            ForEach(0..<items.count, id: \.self) { index in
                InfoItemRow(
                    item: items[index],
                    index: index,
                    isEditing: $isEditing,
                    editingText: $editingText,
                    editingIndex: $editingIndex,
                    saveChanges: saveChanges
                )
                if index < items.count - 1 {
                    Divider()
                        .padding(.vertical, 12)
                }
            }
        }
        .padding(18)
    }

    private func saveChanges(index: Int, newValue: String) {
        Task {
            await userViewModel.updateUser(with: [
                items[index].field: newValue
            ])
            isEditing = false
            editingIndex = nil
        }
    }
}

struct InfoItemRow: View {
    let item: InfoItem
    let index: Int
    @Binding var isEditing: Bool
    @Binding var editingText: String
    @Binding var editingIndex: Int?
    var saveChanges: (Int, String) -> Void

    struct CustomTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .font(.footnote)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Text(item.name)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
                if item.edit {
                    Text(
                        isEditing && editingIndex == index
                            ? "Cancel" : item.value.isEmpty ? "Add" : "Edit"
                    )
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .underline()
                    .onTapGesture {
                        if isEditing && editingIndex == index {
                            isEditing = false
                            editingIndex = nil
                        } else {
                            isEditing = true
                            editingIndex = index
                            editingText = item.value
                        }
                    }
                }
            }
            if isEditing && editingIndex == index {
                TextField(item.name, text: $editingText)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding(.vertical, 12)
                Button(action: {
                    saveChanges(index, editingText)
                }) {
                    Text("Save")
                        .foregroundColor(.black)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.neutral100)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Spacer()
                }
            } else {
                Text(item.value.isEmpty ? "Not provided" : item.value)
                    .font(.footnote)
                    .foregroundColor(.neutral70)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 3)
            }
        }
        .animation(.easeInOut, value: isEditing && editingIndex == index)
    }
}

#Preview {
    struct PersonalInfoView_Preview: View {
        var body: some View {
            PersonalInfoView()
                .environmentObject(UserViewModel())
        }
    }
    return PersonalInfoView_Preview()
}
