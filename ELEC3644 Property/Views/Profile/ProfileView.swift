//
//  ProfileView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var user: User { userViewModel.user }
    var body: some View {
        NavigationStack {
            VStack {
                if userViewModel.isLoggedIn() {
                    NavigationLink(destination: ProfileDetailedView(user: user)) {
                        HStack(spacing: 12) {
                            UserAvatarView(user: user)
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(10)
                                .foregroundColor(.neutral70)
                        }
                    }
                    Spacer()
                    NavigationLink(destination: HostTransitionScreen()) {
                        HStack {
                            Image(systemName: "link")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .symbolEffect(.variableColor)
                                .padding(.leading, 16)
                            Text(
                                userViewModel.userRole == .host
                                    ? "Switch to exploring" : "Switch to hosting"
                            )
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.trailing, 16)
                            .addShadow()
                        }
                        .background(.black)
                        .cornerRadius(36)
                        .padding(.vertical, 24)
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("Login to start exploring. ")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral70)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        LoginButton()
                            .padding(.bottom, 12)
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.footnote)
                                .foregroundColor(.black)
                            NavigationLink {
                                LoginView()  // TODO: Create Sign up view
                            } label: {
                                Text("Sign up")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .underline()
                                    .foregroundColor(.black)
                            }
                        }
                        LazyVStack {
                            NavigationLink(destination: SettingsView()) {
                                HStack(spacing: 15) {
                                    Image(systemName: "gearshape")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.black)
                                    Text("Settings")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .fontWeight(.semibold)
                                        .frame(width: 12, height: 12)
                                }
                                .padding(.vertical, 6)
                            }
                            Divider()
                            NavigationLink(destination: SettingsView()) {
                                HStack(spacing: 15) {
                                    Image(systemName: "accessibility")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.black)
                                    Text("Accessibility")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .fontWeight(.semibold)
                                        .frame(width: 12, height: 12)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(.vertical, 18)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 18)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
