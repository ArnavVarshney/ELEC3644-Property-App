//
//  HostTransitionScreen.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//

import AVKit
import SwiftUI

struct HostTransitionScreen: View {
    @State private var avPlayer = AVPlayer(
        url: Bundle.main.url(forResource: "hostTransition", withExtension: "mov")!)
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var navigateToExplore = false

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
                    userViewModel.userRole == .host
                        ? "Switching to hosting" : "Switching to exploring"
                )
                .font(.system(size: 12, weight: .semibold))
            }
            .onAppear {
                if userViewModel.userRole != .host {
                    userViewModel.userRole = .host
                } else {
                    userViewModel.userRole = .guest
                }
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem,
                    queue: .main
                ) { _ in
                    avPlayer.seek(to: .zero)
                    navigateToExplore = true
                }
                avPlayer.play()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToExplore) {
            ProfileView()
                .interactiveDismissDisabled(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    HostTransitionScreen()
        .environmentObject(UserViewModel())
}
