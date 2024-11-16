//
//  LoginView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 30/10/2024.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        // Check if the user is already logged in
        if !isLoggedIn {
            Form {
                Section(header: Text("Login")) {
                    TextField("Email", text: $username)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }

                Button(action: login) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Failed"), message: Text(alertMessage),
                    dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Login")
            .onAppear {
                checkLoginStatus()
            }
        } else {
            // Content for logged-in users
            Text("Welcome back, \(viewModel.user.name)!")
                .font(.largeTitle)
                .padding()
        }
    }

    private func checkLoginStatus() {
        let currentUserID = UserDefaults.standard.string(forKey: "currentUserID")
        if currentUserID != nil {
            isLoggedIn = true
            // Fetch user data if needed
            Task {
                await viewModel.fetchUser(with: currentUserID!)
            }
        }
    }

    private func login() {
        Task {
            do {
                // Call the login method from UserViewModel
                let user = try await UserViewModel.login(with: username, password: password)

                // Update user data in view model
                viewModel.user = user
                isLoggedIn = true
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
    }
}
