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
                Text("Switching to hosting")
                    .font(.system(size: 12, weight: .semibold))
            }
            .onAppear {
                userViewModel.userRole = .host
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem,
                    queue: .main
                ) { _ in
                    navigateToExplore = true
                }
                avPlayer.play()
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToExplore) {
            ExploreView()
                .interactiveDismissDisabled(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    HostTransitionScreen()
        .environmentObject(UserViewModel())
}
