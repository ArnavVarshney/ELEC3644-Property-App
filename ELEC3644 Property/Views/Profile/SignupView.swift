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
    @State private var avatarUrl: String = ""
    @State private var showAlert: Bool = false
    @State private var isEditing: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var alertMessage: String = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
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

                Text(LocalizedStringKey("Phone"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)

                TextField("Phone (optional)", text: $phone)
                    .textFieldStyle(LoginTextFieldStyle())
                    .keyboardType(.numberPad)

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
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                    } else {
                        Text("Signup")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.neutral100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                    }
                }
                .disabled(isLoading)
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
                                    .resizable()
                                    .frame(width: 15, height: 15)
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
                        avatarUrl = imageUrl
                        userViewModel.user.avatarUrl = imageUrl
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isEditing = false
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }

    private func signup() {
        isLoading = true
        Task {
            do {
                if name.isEmpty || username.isEmpty || password.isEmpty {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                    return
                } else if !username.contains("@") {
                    alertMessage = "Invalid email."
                    showAlert = true
                    return
                } else if !phone.isEmpty && (phone.count != 8 || !phone.allSatisfy(\.isNumber)) {
                    alertMessage = "Invalid phone number."
                    showAlert = true
                    return
                }

                let res: User = try await UserViewModel.signup(
                    with: name, email: username, phone: phone, password: password,
                    avatarUrl: avatarUrl)

                userViewModel.user = res
                userViewModel.initTask()
                UserDefaults.standard.set(res.id.uuidString, forKey: "currentUserID")
            } catch {
                alertMessage = "Failed to create account."
                showAlert = true
            }
            isLoading = false
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .environmentObject(UserViewModel())
    }
}
