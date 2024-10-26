//
//  TripsView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 27/10/24.
//

import SwiftUI

struct TripsView: View {
  @EnvironmentObject var userViewModel: UserViewModel

  var user: User {
    userViewModel.user
  }

  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "airplane")
          .font(.largeTitle)
          .padding()

        Text("You don't have any trips")
          .font(.footnote)
          .fontWeight(.bold)
          .padding(4)

        Text("When you book a new trip, it will appear here.")
          .font(.footnote)
          .foregroundColor(.neutral60)
          .padding(4)
      }
      .navigationTitle("Trips")
    }
  }
}

#Preview {
  TripsView()
    .environmentObject(UserViewModel())
}
