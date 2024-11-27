//
//  BottomBar.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 18/11/2024.
//

import SwiftUI

struct BottomBar: View {
    @Environment(\.dismiss) private var dismiss
    var onSubmit: () -> Void = {}

    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.system(size: 16))
                    .foregroundColor(.neutral100)
                    .padding()
                    .cornerRadius(10)
            }
            Spacer()
            Button {
                onSubmit()
                dismiss()
            } label: {
                Text("Search")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.neutral10)
                    .padding()
                    .background(Color.neutral100)
                    .cornerRadius(10)
            }
        }
    }
}
