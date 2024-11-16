//
//  Slider.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct IntSlider: View {
    @State private var isEditing: Bool = false
    @Binding var range: Double
    var bottomRange: Double
    var topRange: Double
    var step: Double
    var body: some View {
        VStack {
            Slider(
                value: $range,
                in: bottomRange...topRange,
                step: step,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            .tint(.primary60)
            Text("\(String(Int(range)))")
                .foregroundColor(isEditing ? .neutral60 : .primary60)
        }
    }
}
