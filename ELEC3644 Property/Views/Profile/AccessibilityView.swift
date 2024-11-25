//
//  AccessibilityView.swift
//  ELEC3644 Property
//
//  Created by Arnav Varshney on 18/11/24.
//

import SwiftUI

struct AccessibilityView: View {
    @EnvironmentObject var mapSettingsViewModel: MapSettingsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
//    @State private var mapZoomEnabled = false
//    @State private var mapPanEnabled = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Toggle(isOn: $mapSettingsViewModel.mapZoomEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Map zoom controls")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral100)
                        Text("Zoom in and out with dedicated buttons")
                            .font(.footnote)
                            .foregroundColor(.neutral70)
                    }
                    .padding(.vertical, 12)
                }
                Toggle(isOn: $mapSettingsViewModel.mapPanEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Map pan controls")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.neutral100)
                        Text("Pan around the map with directional buttons")
                            .font(.footnote)
                            .foregroundColor(.neutral70)
                    }
                    .padding(.vertical, 12)
                }
                Spacer()
            }
//            .onChange(of: mapZoomEnabled) {
//                UserDefaults.standard.set(mapZoomEnabled, forKey: "mapZoomEnabled")
//            }
//            .onChange(of: mapPanEnabled) {
//                UserDefaults.standard.set(mapPanEnabled, forKey: "mapPanEnabled")
//            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle("Accessibility")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}

#Preview {
    struct AccessibilityView_Preview: View {
        var body: some View { AccessibilityView() } }
    return AccessibilityView_Preview()
}
