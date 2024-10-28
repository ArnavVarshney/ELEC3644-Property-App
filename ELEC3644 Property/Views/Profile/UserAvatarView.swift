//
//  UserAvatarView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 16/10/2024.
//

import SwiftUI

struct UserAvatarView: View {
    var user: User
    var size: CGFloat = 36

    init(user: User, size: CGFloat = 36) {
        self.user = user
        self.size = size
    }

    var body: some View {
        AsyncImage(url: URL(string: user.avatarUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } placeholder: {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

#Preview {
    struct UserAvatarView_Preview: View {
        @EnvironmentObject var userViewModel: UserViewModel

        var body: some View {
            UserAvatarView(user: userViewModel.user)
        }
    }
    return UserAvatarView_Preview()
        .environmentObject(UserViewModel())
}
