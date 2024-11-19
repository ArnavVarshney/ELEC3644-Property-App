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
        .sheet(isPresented: $showModal) { LoginView() }
    }
}

struct LoginView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var rememberMe: Bool = false  // State for "Remember Me"

    var body: some View {
        NavigationStack {
            VStack {
                Image("loginView_real")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)  // Adjust height as necessary

                if !isLoggedIn {
                    Form {
                        Section(header: Text("Login")) {
                            TextField("Email", text: $username)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)

                            SecureField("Password", text: $password)

                            Toggle("Remember Me", isOn: $rememberMe)  // Remember Me toggle
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
                            title: Text("Login Failed"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .navigationTitle("Login")
                    .onAppear { checkLoginStatus() }
                } else {
                    // Content for logged-in users
                    Text("Welcome back, \(viewModel.user.name)!").font(.largeTitle).padding()
                }
            }
            .onAppear(perform: loadCredentials)  // Load saved credentials if available
        }
    }

    private func loadCredentials() {
        // Load saved credentials from UserDefaults if "Remember Me" was previously enabled
        let savedUsername = UserDefaults.standard.string(forKey: "savedUsername") ?? ""
        let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") ?? ""

        if !savedUsername.isEmpty {
            username = savedUsername
            password = savedPassword  // Optionally pre-fill password
            rememberMe = true  // Set toggle to true if credentials are loaded
        }
    }

    private func checkLoginStatus() {
        let currentUserID = UserDefaults.standard.string(forKey: "currentUserID")
        if currentUserID != nil {
            isLoggedIn = true
            // Fetch user data if needed
            Task { await viewModel.fetchUser(with: currentUserID!) }
        }
    }

    private func login() {
        Task {
            do {
                // Call the login method from UserViewModel
                let user = try await UserViewModel.login(with: username, password: password)

                // Update user data
                viewModel.user = user
                viewModel.initTask()

                // Save credentials if "Remember Me" is checked
                if rememberMe {
                    UserDefaults.standard.set(username, forKey: "savedUsername")
                    UserDefaults.standard.set(password, forKey: "savedPassword")
                } else {
                    // Clear saved credentials if not remembered
                    UserDefaults.standard.removeObject(forKey: "savedUsername")
                    UserDefaults.standard.removeObject(forKey: "savedPassword")
                }

                UserDefaults.standard.set(user.id.uuidString, forKey: "currentUserID")
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
        LoginView().environmentObject(UserViewModel())
    }
}
