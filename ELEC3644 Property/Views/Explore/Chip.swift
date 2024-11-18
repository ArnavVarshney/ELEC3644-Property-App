//
//  Chip.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct Chip: View {
    let content: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: {
            withAnimation(.snappy) {
                action()
            }
        }) {
            Text(
                content.capitalized
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.primary60 : Color.neutral30)
            .cornerRadius(40)
            .foregroundColor(isSelected ? Color.neutral10 : Color.neutral80)
            .animation(.snappy, value: isSelected)
            .lineLimit(1)
        }
    }
}

#Preview {
    struct Chip_Preview: View {
        @State var selected = false
        var body: some View {
            Chip(content: "Hello, World!", isSelected: selected) {
                selected.toggle()
            }
        }
    }
    return Chip_Preview()
}
