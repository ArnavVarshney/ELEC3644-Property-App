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
                .foregroundColor(.black)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.neutral100)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
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
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

struct LoginView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            TextField("Email", text: $username)
                .textFieldStyle(LoginTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.top, 24)

            SecureField("Password", text: $password)
                .textFieldStyle(LoginTextFieldStyle())
                .padding(.top, 12)

            Button(action: login) {
                Text("Login")
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
                .navigationTitle("Login")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }
                }

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
        Task {
            do {
                let user = try await UserViewModel.login(with: username, password: password)
                viewModel.user = user
                viewModel.initTask()
                UserDefaults.standard.set(user.id.uuidString, forKey: "currentUserID")
            } catch {
                alertMessage = "Invalid email or password."
                showAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
    }
}
