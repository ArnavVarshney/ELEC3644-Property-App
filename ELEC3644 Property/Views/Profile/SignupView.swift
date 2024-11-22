import PhotosUI
//
//  SignupView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 22/11/24.
//
import SwiftUI

struct SignupView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var isEditing: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    UserAvatarView(user: userViewModel.user, size: 144)
                        .padding(.top, 24)
                    if isEditing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .neutral100))
                            .scaleEffect(1.5)
                            .frame(width: 144, height: 144)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(.top, 24)
                    }
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 1,
                        matching: .images
                    ) {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .addShadow()
                    }
                    .disabled(isEditing)
                    .offset(x: 56, y: 56)
                }

                Text(LocalizedStringKey("Name"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)

                TextField("Name", text: $name)
                    .textFieldStyle(LoginTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                Text(LocalizedStringKey("Phone"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

                TextField("Phone (optional)", text: $username)
                    .textFieldStyle(LoginTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                Text(LocalizedStringKey("Email"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

                TextField("Email", text: $username)
                    .textFieldStyle(LoginTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                Text(LocalizedStringKey("Password"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

                SecureField("Password", text: $password)
                    .textFieldStyle(LoginTextFieldStyle())

                Button(action: signup) {
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
                    .navigationTitle("Signup")
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
        }
        .onChange(
            of: selectedItems
        ) { _, newValue in
            Task {
                isEditing = true
                if let data = try? await newValue[0].loadTransferable(type: Data.self) {
                    let res: Data = try await NetworkManager.shared.uploadImage(
                        imageData: data)
                    let json = try JSONSerialization.jsonObject(with: res, options: [])
                    if let json = json as? [String: Any],
                        let imageUrl = json["url"] as? String
                    {
                        if await !userViewModel.updateUser(with: [
                            "avatarUrl": imageUrl
                        ]) {
                            alertMessage = "Failed to update profile picture."
                            showAlert = true
                        }
                    }
                }
                sleep(1)
                isEditing = false
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

    private func signup() {
        Task {
            do {
                let user = try await UserViewModel.login(with: username, password: password)
                userViewModel.user = user
                userViewModel.initTask()
                UserDefaults.standard.set(user.id.uuidString, forKey: "currentUserID")
            } catch {
                alertMessage = "Invalid email or password."
                showAlert = true
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .environmentObject(UserViewModel())
    }
}
