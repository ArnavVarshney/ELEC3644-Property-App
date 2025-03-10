//
//  HostTransitionScreen.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//
import AVKit
import SwiftUI

struct HostTransitionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var avPlayer = AVPlayer(
        url: Bundle.main.url(forResource: "hostTransition", withExtension: "mov")!)
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    VideoPlayer(player: avPlayer)
                        .aspectRatio(782 / 580, contentMode: .fit)
                        .padding(.horizontal, 48)
                        .overlay(
                            Rectangle()
                                .stroke(Color.white, lineWidth: 2)
                                .padding(.horizontal, 48)
                        )
                }
                Text(
                    userViewModel.userRole == .host || userViewModel.userRole == .agent
                        ? "Switching to hosting" : "Switching to exploring"
                )
                .font(.system(size: 12, weight: .semibold))
            }
            .onAppear {
                if userViewModel.userRole == .guest {
                    if userViewModel.isAgent(with: userViewModel.user) {
                        userViewModel.userRole = .agent
                    } else {
                        userViewModel.userRole = .host
                    }
                } else {
                    userViewModel.userRole = .guest
                }
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem,
                    queue: .main
                ) { _ in
                    avPlayer.seek(to: .zero)
                    dismiss()
                }
                avPlayer.play()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HostTransitionScreen()
        .environmentObject(UserViewModel())
}
