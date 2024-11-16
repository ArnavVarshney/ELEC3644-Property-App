//
//  LocationSheetView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//
import SwiftUI

struct LocationSheetView: View {
    @Binding var tag: Tag
    @State var selectArea: String = "HK Island"
    @State var selectDistrict: String = ""
    @State var selectSubdistrict: String = ""
    @Environment(\.dismiss) var dismiss
    var districtChoices: [String] {
        Location.districts[selectArea] ?? []
    }

    var subDistrictChoices: [String] {
        Location.subDistricts[selectDistrict] ?? []
    }

    var body: some View {
        NavigationView {
            List {
                Picker("Area", selection: $selectArea) {
                    ForEach(Location.areas, id: \.self) { area in
                        Text(area)
                    }
                }
                Picker("District", selection: $selectDistrict) {
                    ForEach(districtChoices, id: \.self) { district in
                        Text(district)
                    }
                }
                Picker("Sub-district", selection: $selectSubdistrict) {
                    ForEach(subDistrictChoices, id: \.self) { subDistrict in
                        Text(subDistrict)
                    }
                }
            }
            .navigationTitle("Location")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Select") {
                        tag.content = selectSubdistrict
                        dismiss()
                    }
                    //                    .disabled(buttonDisabled)
                    //                    .foregroundColor(buttonDisabled ? .neutral60 : .primary60)
                }
            }
        }
    }
}

#Preview {
    struct LocationSheetView_Preview: View {
        @State private var tag = Tag(label: "Location")
        var body: some View {
            LocationSheetView(tag: $tag)
        }
    }
    return LocationSheetView_Preview()
}
