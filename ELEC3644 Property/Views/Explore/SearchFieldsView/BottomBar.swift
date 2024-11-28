//
//  BottomBar.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 18/11/2024.
//

import SwiftUI

struct BottomBar: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var propertyViewModel: PropertyViewModel
    var onSubmit: () -> Void = {}
    @State private var isLoading = false

    var body: some View {
        HStack {
            Button {
                propertyViewModel.searchFields = PropertySearchField()
            } label: {
                Text("Reset")
                    .font(.system(size: 16))
                    .foregroundColor(.neutral100)
                    .padding()
                    .cornerRadius(10)
            }
            Spacer()
            Button {
                isLoading = true
                onSubmit()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                    dismiss()
                }
            } label: {
                if !isLoading {
                    Text("Search")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: 80)
                        .foregroundColor(.neutral10)
                        .padding()
                        .background(Color.neutral100)
                        .cornerRadius(10)
                    
                } else {
                    ProgressView()
                        .frame(maxWidth: 80)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.neutral100)
                        .cornerRadius(10)
                }
            }
        }
    }
}
