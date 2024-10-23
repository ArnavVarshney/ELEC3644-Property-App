//
//  backButton.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 11/10/2024.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
  @Environment(\.dismiss) private var dismiss

  func body(content: Content) -> some View {
    content
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarLeading) {
          HStack {
            Button(action: {
              self.dismiss()
            }) {
              Image(systemName: "chevron.left")
                .frame(width: 18, height: 18)
                .foregroundColor(.black)
                .padding(12)
                .background(
                  Circle()
                    .fill(Color.white)
                )
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
            }
          }
        }
      }
  }
}

extension View {
  func backButton() -> some View {
    self.modifier(BackButtonModifier())
  }
}

#Preview {
  NavigationStack {
    VStack {
      Text("Hello")
      Spacer()
    }
    .backButton()
    .navigationTitle("Test")
  }
}
