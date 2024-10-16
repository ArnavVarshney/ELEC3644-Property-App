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
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.neutral100)
                                .padding(24)
                                .background(Circle().fill(Color.neutral20))
                                .shadow(color: .neutral30, radius: 4, x: 0, y: 4)
                        }
                        Spacer()
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
