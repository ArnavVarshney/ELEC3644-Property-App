//
//  EstateSearchFieldsView.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//

import SwiftUI

struct EstateSearchFieldsView: View {
    @State private var estateTypes: Set<String> = []
    @State private var facilities: Set<String> = []
    @State private var yearBuilt: Double = 1970

    let estateTypesList = ["Residential", "Commercial", "Mixed-use", "Gated Community"]
    let facilitiesList = ["Playground", "Clubhouse", "Security", "Shopping Center", "School"]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Estate Type")
                .font(.headline)
            ChipGrid(items: estateTypesList, selectedItems: $estateTypes)

            Text("Facilities")
                .font(.headline)
            ChipGrid(items: facilitiesList, selectedItems: $facilities)

            Text("Year Built")
                .font(.headline)
            IntSlider(range: $yearBuilt, bottomRange: 1970, topRange: 2023, step: 1)
        }
    }
}
