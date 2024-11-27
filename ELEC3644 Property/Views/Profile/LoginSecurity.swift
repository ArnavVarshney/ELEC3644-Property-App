//
//  LoginSecurity.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 18/11/24.
//
import SwiftUI

struct LoginSecurityView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDeactivateConfirmation = false
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey("Password"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.neutral100)
                Text(LocalizedStringKey("Current Password"))
                    .font(.footnote)
                    .foregroundColor(.neutral100)
                    .padding(.top, 3)
                SecureField("", text: $currentPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                Text(LocalizedStringKey("New Password"))
                    .font(.footnote)
                    .foregroundColor(.neutral100)
                    .padding(.top)
                SecureField("", text: $newPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                Text(LocalizedStringKey("Confirm Password"))
                    .font(.footnote)
                    .foregroundColor(.neutral100)
                    .padding(.top)
                SecureField("", text: $confirmPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                Button(action: {
                    if !currentPassword.isEmpty && newPassword == confirmPassword
                        && newPassword.count >= 4
                    {
                        Task {
                            if await userViewModel.updateUser(with: [
                                "oldPassword": currentPassword, "newPassword": newPassword,
                            ]) {
                                userViewModel.logout()
                                dismiss()
                            } else {
                                alertMessage = "Failed to update password."
                                showAlert = true
                            }
                        }
                    } else {
                        if currentPassword.isEmpty {
                            alertMessage = "Current password is required."
                        } else if newPassword.count < 4 {
                            alertMessage = "New password must be at least 4 characters long."
                        } else {
                            alertMessage = "Passwords do not match."
                        }
                        showAlert = true
                    }
                }) {
                    Text("Update password")
                        .foregroundColor(.neutral100)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.neutral100)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.neutral100, lineWidth: 1)
                        )
                }
                .padding(.top, 18)
                Divider()
                    .padding(.vertical)
                Text(LocalizedStringKey("Account"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.neutral100)
                HStack {
                    Text(LocalizedStringKey("Deactivate your account"))
                        .font(.footnote)
                        .foregroundColor(.neutral100)
                        .padding(.top, 3)
                    Spacer()
                    Button {
                        showDeactivateConfirmation = true
                        showAlert = true
                    } label: {
                        Text("Deactivate")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 24)
                Divider()
                    .padding(.vertical)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle("Security")
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
            .alert(isPresented: $showAlert) {
                if showDeactivateConfirmation {
                    Alert(
                        title: Text("Confirm Deactivate"),
                        message: Text("Are you sure you want to deactivate?"),
                        primaryButton: .destructive(Text("Deactivate")) {
                            Task {
                                if await userViewModel.updateUser(with: ["isActive": "false"]) {
                                    userViewModel.logout()
                                    dismiss()
                                } else {
                                    alertMessage = "Failed to deactivate account."
                                    showAlert = true
                                    showDeactivateConfirmation = false
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                } else {
                    Alert(
                        title: Text("Error"), message: Text(alertMessage),
                        dismissButton: .default(Text("OK")))
                }
            }

        }
    }
}

#Preview {
    struct LoginSecurityView_Preview: View {
        var body: some View {
            LoginSecurityView()
                .environmentObject(UserViewModel())
        }
    }
    return LoginSecurityView_Preview()
}
