//
//  HostTransitionScreen.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 31/10/24.
//

import AVKit
import SwiftUI

struct HostTransitionScreen: View {
    @EnvironmentObject var userViewModel: UserViewModel

    let avPlayer = AVPlayer(
        url: Bundle.main.url(forResource: "hostTransition", withExtension: "mov")!)

    var body: some View {
        VStack {
            VideoPlayer(player: avPlayer)
                .aspectRatio(782 / 580, contentMode: .fit)
                .frame(width: 300, height: 300)
                .background(.white)
                .padding(48)

        }.onAppear {
            avPlayer.play()
        }
    }
}

#Preview {
    HostTransitionScreen()
        .environmentObject(UserViewModel())
}
