//
//  ForgotPassword.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 22/11/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            Text(LocalizedStringKey("Email"))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)

            TextField("Email", text: $username)
                .textFieldStyle(LoginTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            Button(action: login) {
                Text("Submit")
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.neutral100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
            }
            .background(Color.black)
            .cornerRadius(8)
            .padding(.top, 12)

            Spacer()
                .navigationTitle("Forgot Password")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
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

    private func login() {
        Task {
            do {
                if username.isEmpty {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                    return
                } else if !username.contains("@") {
                    alertMessage = "Invalid email format."
                    showAlert = true
                    return
                }
                let _: User = try await NetworkManager.shared.post(
                    url: "/users/forgot-password", body: ["email": username])
                alertMessage = "Password reset to \"pwd\"."
                showAlert = true
            } catch {
                alertMessage = "An error occurred. Please ensure this email is registered."
                showAlert = true
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(UserViewModel())
    }
}
