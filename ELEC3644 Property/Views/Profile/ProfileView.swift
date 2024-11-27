//
//  ProfileView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//
import SwiftUI

struct SettingsItem {
    let destination: AnyView
    let iconName: String
    let title: String
    let subtitle: String
}

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showLogoutConfirmation = false
    @State private var showModal = false
    var user: User { userViewModel.user }

    var body: some View {
        NavigationStack {
            ZStack {
                if userViewModel.isLoggedIn() {
                    ScrollView(showsIndicators: false) {
                        NavigationLink(destination: ProfileDetailedView(user: user)) {
                            HStack(spacing: 18) {
                                UserAvatarView(user: user, size: 64)
                                    .addShadow()
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                        .font(.headline)
                                    Text("Show profile")
                                        .font(.footnote)
                                        .foregroundColor(.neutral70)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(.neutral100)
                            }
                        }

                        if userViewModel.userRole != .host {
                            NavigationLink(
                                destination: HostTransitionScreen().toolbar(.hidden, for: .tabBar)
                            ) {
                                HStack(spacing: 24) {
                                    VStack(spacing: 12) {
                                        Text("List your property")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fontWeight(.semibold)
                                        Text("It's easy to start hosting and earn extra income")
                                            .font(.caption)
                                            .foregroundColor(.neutral70)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.leading, 24)
                                    .padding(.vertical, 24)

                                    Image("hosting_advert")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 96, height: 96)
                                        .foregroundColor(.neutral100)
                                        .padding(.trailing, 12)
                                }
                                .background(.white)
                                .cornerRadius(12)
                                .addShadow()
                                .padding(.horizontal, 3)
                                .padding(.vertical, 24)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            NavigationLink(
                                destination: HostTransitionScreen().toolbar(.hidden, for: .tabBar)
                            ) {
                                HStack(spacing: 24) {
                                    VStack(spacing: 12) {
                                        Text("Explore properties")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fontWeight(.semibold)
                                        Text("Find your next home or investment")
                                            .font(.caption)
                                            .foregroundColor(.neutral70)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.leading, 24)
                                    .padding(.vertical, 24)

                                    Image("hosting_advert")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 96, height: 96)
                                        .foregroundColor(.neutral100)
                                        .padding(.trailing, 12)
                                }
                                .background(.white)
                                .cornerRadius(12)
                                .addShadow()
                                .padding(.horizontal, 3)
                                .padding(.vertical, 24)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        Text("Settings")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 12)
                        SettingsList(items: [
                            SettingsItem(
                                destination: AnyView(GeneralSettingsView()), iconName: "gearshape",
                                title: "General", subtitle: ""),
                            SettingsItem(
                                destination: AnyView(PersonalInfoView()),
                                iconName: "person.crop.circle",
                                title: "Personal Information", subtitle: ""),
                            SettingsItem(
                                destination: AnyView(LoginSecurityView()),
                                iconName: "shield.righthalf.filled", title: "Login & Security",
                                subtitle: ""),
                            SettingsItem(
                                destination: AnyView(AccessibilityView()),
                                iconName: "accessibility",
                                title: "Accessibility", subtitle: ""),
                        ])
                        Button {
                            showLogoutConfirmation = true
                        } label: {
                            Text("Log out")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .underline()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 24)
                        }
                        .alert(isPresented: $showLogoutConfirmation) {
                            Alert(
                                title: Text("Confirm Logout"),
                                message: Text("Are you sure you want to log out?"),
                                primaryButton: .destructive(Text("Log out")) {
                                    userViewModel.logout()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .refreshable {
                        userViewModel.initTask()
                    }
                    VStack {
                        Spacer()
                        NavigationLink(
                            destination: HostTransitionScreen().toolbar(.hidden, for: .tabBar)
                        ) {
                            HStack {
                                Image(systemName: "link")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .symbolEffect(.pulse, options: .speed(0.75))
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
                            .padding(.horizontal, 4)
                            .background(.neutral100)
                            .cornerRadius(36)
                            .padding(.vertical, 24)
                        }
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
                                .foregroundColor(.neutral100)
                            Button {
                                showModal = true
                            } label: {
                                Text("Sign up")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .underline()
                                    .foregroundColor(.neutral100)
                            }
                        }
                        Text("Settings")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)
                        SettingsList(items: [
                            SettingsItem(
                                destination: AnyView(GeneralSettingsView()), iconName: "gearshape",
                                title: "General", subtitle: ""),
                            SettingsItem(
                                destination: AnyView(AccessibilityView()),
                                iconName: "accessibility",
                                title: "Accessibility", subtitle: ""),
                        ])
                        Spacer()
                    }
                    .sheet(isPresented: $showModal) { SignupView().presentationDetents([.large]) }
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

struct SettingsList: View {
    let items: [SettingsItem]

    var body: some View {
        LazyVStack {
            ForEach(0..<items.count, id: \.self) { index in
                NavigationLink(destination: items[index].destination) {
                    HStack(spacing: 15) {
                        Image(systemName: items[index].iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.neutral100)
                        Text(LocalizedStringKey(items[index].title))
                            .font(.footnote)
                            .foregroundColor(.neutral100)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral100)
                            .frame(width: 12, height: 12)
                    }
                    .padding(.vertical, 3)
                }
                if index < items.count - 1 {
                    Divider()
                }
            }
        }
    }
}
