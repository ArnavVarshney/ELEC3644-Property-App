//
//  ProfileView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 15/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var user: User {
        userViewModel.user
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(spacing: 12) {
                    UserAvatarView(user: user)
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                    }
                    Spacer()
                    NavigationLink(
                        destination: ProfileDetailed(userViewModel: userViewModel),
                        label: {
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(10)
                        })
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
