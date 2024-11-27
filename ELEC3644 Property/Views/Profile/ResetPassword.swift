//
//  ResetPassword.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 25/11/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading = false
    var userId: String = ""

    var body: some View {
        NavigationStack {
            Text(LocalizedStringKey("New Password"))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.neutral100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)

            SecureField("Password", text: $newPassword)
                .textFieldStyle(LoginTextFieldStyle())

            Text(LocalizedStringKey("Confirm Password"))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.neutral100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(LoginTextFieldStyle())

            Button(action: resetPassword) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                } else {
                    Text("Submit")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.neutral100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                }
            }
            .disabled(isLoading)
            .background(Color.neutral100)
            .cornerRadius(8)
            .padding(.top, 12)

            Spacer()
                .navigationTitle("Reset Password")
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

        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertMessage.contains("error") ? "Error" : "Success"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }

    private func resetPassword() {
        isLoading = true
        Task {
            do {
                if newPassword.isEmpty || confirmPassword.isEmpty {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                    return
                } else if newPassword != confirmPassword {
                    alertMessage = "Passwords do not match."
                    showAlert = true
                    return
                }
                let _: User = try await NetworkManager.shared.post(
                    url: "/users/reset-password", body: ["id": userId, "newPassword": newPassword])
                alertMessage = "Password reset successfully."
                showAlert = true
            } catch {
                alertMessage = "An error occurred. Please try again."
                showAlert = true
            }
        }
        isLoading = false
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
            .environmentObject(UserViewModel())
    }
}
