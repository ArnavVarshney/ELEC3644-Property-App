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
        VStack(alignment: .leading) {
            VStack {
                Text("Years of Experience")
                    .font(.headline)
                IntSlider(range: $experience, bottomRange: 0, topRange: 30, step: 1)
            }

            VStack {
                Text("Specializations")
                    .font(.headline)
                ChipGrid(items: specializationsList, selectedItems: $specializations)
            }

            VStack {
                Text("Languages")
                    .font(.headline)
                ChipGrid(items: languagesList, selectedItems: $languages)
            }
        }
    }
}

#Preview {
    AgentSearchFieldsView()
}
