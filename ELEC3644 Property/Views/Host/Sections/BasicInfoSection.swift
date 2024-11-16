//
//  BasicInfoSection.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//
import SwiftUI

struct BasicInfoSection: View {
    @Binding var propertyName: String
    @Binding var address: String
    @Binding var estate: String
    @Binding var buildingDirection: String
    @Binding var buildingAge: String
    @Binding var selectedArea: String
    @Binding var selectedDistrict: String
    @Binding var selectedSubDistrict: String
    var body: some View {
        Form {
            Section(header: Text("Property Information")) {
                TextField("Property Name", text: $propertyName)
                TextField("Address", text: $address)
                TextField("Estate", text: $estate)
                TextField("Building Direction", text: $buildingDirection)
                TextField("Building Age", text: $buildingAge)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Location")) {
                Picker("Area", selection: $selectedArea) {
                    Text("Select Area").tag("")
                    ForEach(Location.areas, id: \.self) { area in
                        Text(area).tag(area)
                    }
                }
                if !selectedArea.isEmpty {
                    Picker("District", selection: $selectedDistrict) {
                        Text("Select District").tag("")
                        ForEach(Location.districts[selectedArea] ?? [], id: \.self) { district in
                            Text(district).tag(district)
                        }
                    }
                }
                if !selectedDistrict.isEmpty {
                    Picker("Sub-District", selection: $selectedSubDistrict) {
                        Text("Select Sub-District").tag("")
                        ForEach(Location.subDistricts[selectedDistrict] ?? [], id: \.self) {
                            subDistrict in
                            Text(subDistrict).tag(subDistrict)
                        }
                    }
                }
            }
        }
    }
}

struct BasicInfoSection_Previews: PreviewProvider {
    static var previews: some View {
        BasicInfoSection(
            propertyName: .constant(""),
            address: .constant(""),
            estate: .constant(""),
            buildingDirection: .constant(""),
            buildingAge: .constant(""),
            selectedArea: .constant(""),
            selectedDistrict: .constant(""),
            selectedSubDistrict: .constant("")
        )
    }
}
