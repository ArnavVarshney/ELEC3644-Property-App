//
//  AgentSearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//

import SwiftUI

struct AgentSearchFieldsView: View {
    @State private var experience: Double = 15
    @State private var specializations: Set<String> = []
    @State private var languages: Set<String> = []

    let specializationsList = ["Residential", "Commercial", "Luxury", "Investment", "Rental"]
    let languagesList = ["English", "Cantonese", "Mandarin", "French", "Spanish"]

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Years of Experience")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                IntSlider(range: $experience, bottomRange: 0, topRange: 30, step: 1)
            }

            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Specializations")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                ChipGrid(items: specializationsList, selectedItems: $specializations)
            }

            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Languages")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                ChipGrid(items: languagesList, selectedItems: $languages)
            }
        }
    }
}

#Preview {
    AgentSearchFieldsView()
}
