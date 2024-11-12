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
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Estate Type")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                ChipGrid(items: estateTypesList, selectedItems: $estateTypes)
            }

            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Facilities")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                ChipGrid(items: facilitiesList, selectedItems: $facilities)
            }

            Divider()
            VStack(alignment: .leading, spacing: 12) {
                Text("Year Built")
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                IntSlider(range: $yearBuilt, bottomRange: 1970, topRange: 2023, step: 1)
            }
        }
    }
}

#Preview {
    EstateSearchFieldsView()
}
