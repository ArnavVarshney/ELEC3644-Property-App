//
//  EnlargeMapView_V2.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 12/11/2024.
//
import Contacts
import CoreLocation
import MapKit
import SwiftUI

struct EnlargeMapView_V2: View {
    @State var camera: MapCameraPosition = .automatic
    @State private var showAlert: Bool = false
    @State private var result: String = ""
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    @State private var placemark: CLPlacemark?
    @State private var mapItem: MKMapItem?
    @State private var mapSelection: Int?  // to identify which marker has been tapped
    @State private var showLookAroundScene: Bool = false
    var body: some View {
        NavigationStack {
            Map(position: $camera)
                .navigationTitle("Map")
        }
    }
}

#Preview {
    EnlargeMapView_V2()
}
