//
//  FacilitiesSection.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//

import SwiftUI

struct FacilitiesSection: View {
    @Binding var facilities: [(description: String, measure: String, unit: String)]
    @Binding var facilityDescription: String
    @Binding var facilityMeasure: String
    @Binding var facilityUnit: String
    let addFacility: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Existing Facilities")) {
                ForEach(facilities.indices, id: \.self) { index in
                    Text("\(facilities[index].description): \(facilities[index].measure) \(facilities[index].unit)")
                }
                if facilities.isEmpty {
                    Text("No facilities have been added yet.")
                }
            }
            
            Section(header: Text("Add New Facility")) {
                TextField("Description", text: $facilityDescription)
                TextField("Measure", text: $facilityMeasure)
                    .keyboardType(.numberPad)
                TextField("Unit", text: $facilityUnit)
                
                Button(action: addFacility) {
                    Label("Add Facility", systemImage: "plus.circle.fill")
                        .foregroundColor(.neutral100)
                }
            }
        }
    }
}

struct FacilitiesSection_Previews: PreviewProvider {
    static var previews: some View {
        FacilitiesSection(facilities: .constant([]), facilityDescription: .constant(""), facilityMeasure: .constant(""), facilityUnit: .constant(""), addFacility: {})}
}
