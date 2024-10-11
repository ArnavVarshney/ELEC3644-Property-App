//
//  LocationSheetView.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import SwiftUI

struct LocationSheetView: View {
    @Binding var tag: Tag

    @State var selectArea: String = ""
    @State var selectDistrict: String = ""
    @State var selectSubdistrict: String = ""

    var body: some View {
        NavigationView {
            List {
                Picker("Area", selection: $selectArea) {
                    ForEach(Location.areas, id: \.self) { area in
                        Text(area)
                    }
                }
                .onChange(of: selectArea) {
                    selectDistrict = Location.districts[selectArea]?.first ?? ""
                    selectSubdistrict = Location.subDistricts[selectDistrict]?.first ?? ""
                }
                Picker("District", selection: $selectDistrict) {
                    ForEach(Location.districts[selectArea] ?? [], id: \.self) { district in
                        Text(district)
                    }
                }
                .onChange(of: selectDistrict) {
                    selectSubdistrict = ""
                }
                Picker("Sub-district", selection: $selectSubdistrict) {
                    ForEach(Location.subDistricts[selectDistrict] ?? [], id: \.self) { subDistrict in
                        Text(subDistrict)
                    }
                }
            }
            .navigationTitle("Location")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Select") {
                        tag.content = selectSubdistrict
                    }.foregroundColor(.primary60)
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
