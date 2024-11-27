//
//  LoginView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 30/10/2024.
//

import SwiftUI

struct LoginButton: View {
    @State private var showModal = false
    var body: some View {
        Button(action: { showModal = true }) {
            Text("Login")
                .foregroundColor(.neutral100)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.neutral100)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.neutral100, lineWidth: 1)
                )
        }
        .padding(.top, 24)
        .sheet(isPresented: $showModal) { LoginView().presentationDetents([.medium]) }
    }
}

struct LoginTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.footnote)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.neutral100, lineWidth: 1)
            )
    }
}

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var forgotPassword: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            Text(LocalizedStringKey("Email"))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.neutral100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)

            TextField("Email", text: $username)
                .textFieldStyle(LoginTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            Text(LocalizedStringKey("Password"))
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.neutral100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)

            SecureField("Password", text: $password)
                .textFieldStyle(LoginTextFieldStyle())

            Button(action: { forgotPassword = true }) {
                Text("Forgot password?")
                    .font(.footnote)
                    .foregroundColor(.neutral100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
            }

            Button(action: login) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                } else {
                    Text("Login")
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
                .navigationTitle("Login")
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
        .sheet(isPresented: $forgotPassword) {
            ForgotPasswordView()
                .presentationDetents([.medium])
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }

    private func login() {
        isLoading = true
        Task {
            do {
                if username.isEmpty || password.isEmpty {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                    isLoading = false
                    return
                } else if !username.contains("@") {
                    alertMessage = "Invalid email format."
                    showAlert = true
                    isLoading = false
                    return
                }
                let user = try await UserViewModel.login(with: username, password: password)
                userViewModel.user = user
                userViewModel.initTask()
                inboxViewModel.initTask()
                UserDefaults.standard.set(user.id.uuidString, forKey: "currentUserID")
            } catch {
                alertMessage = "Invalid email or password."
                showAlert = true
            }
            isLoading = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
    }
}
