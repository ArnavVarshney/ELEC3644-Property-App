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
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        self.dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.neutral100)
                                .padding(18)
                                .background(.neutral20)
                                .clipShape(Circle())
                                .shadow(color: .neutral30, radius: 4, x: 0, y: 4)
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
    }
}

extension View {
    func backButton() -> some View {
        self.modifier(BackButtonModifier())
    }
}

#Preview {
    NavigationView {
        VStack {
            Text("Hello")
            Spacer()
        }
        .backButton()
    }
}
