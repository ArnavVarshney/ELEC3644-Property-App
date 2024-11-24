//
//  pointSearchView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 21/11/2024.
//

import Contacts
import MapKit
import SwiftUI

enum Area: String, CaseIterable {
    case hkIsland = "HK Island"
    case kowloon = "Kowloon"
    case newTerritories = "New Territories"

    var districts: [District] {
        switch self {
        case .hkIsland:
            return [.centralAndWestern, .wanChai, .eastern, .southern]
        case .kowloon:
            return [.yauTsimMong, .shamShuiPo, .kowloonCity, .wongTaiSin, .kwunTong]
        case .newTerritories:
            return [
                .kwaiTsing, .tsuenWan, .tuenMun, .yuenLong, .north, .taiPo, .shaTin, .saiKung,
                .islands,
            ]
        }
    }
}

enum District: String, CaseIterable {
    case centralAndWestern = "Central and Western"
    case wanChai = "Wan Chai"
    case eastern = "Eastern"
    case southern = "Southern"

    case yauTsimMong = "Yau Tsim Mong"
    case shamShuiPo = "Sham Shui Po"
    case kowloonCity = "Kowloon City"
    case wongTaiSin = "Wong Tai Sin"
    case kwunTong = "Kwun Tong"

    case kwaiTsing = "Kwai Tsing"
    case tsuenWan = "Tseun Wan"
    case tuenMun = "Tuen Mun"
    case yuenLong = "Yuen Long"
    case north = "North"
    case taiPo = "Tai Po"
    case shaTin = "Shatin"
    case saiKung = "Sai Kung"
    case islands = "Islands"

}

enum ContractType: String, CaseIterable {
    case buy = "Buy"
    case rent = "Rent"
    case lease = "Lease"
}

struct pointSearchView: View {
    @Binding var show: Bool
    @Binding var currentMenu: MenuItem?
    @Binding var mapItem: MKMapItem?  //need to update EnlargeMpaView_V2
//    @Binding var placemark: CLPlacemark? //need to update EnlargeMpaView_V2
//    @State var mapItem: MKMapItem?  //need to update EnlargeMpaView_V2
    @State var errorMessage: String = "Place not found!"
    @State var placemark: CLPlacemark? //need to update EnlargeMpaView_V2
//    @State var showAlert: Bool
    @State private var result: String = ""
    //@State private var showAlert: Bool = false
    @State private var selectedArea: Area = .hkIsland
    @State private var selectedDistrict: District?
    @State private var selectedContract: ContractType = .buy
    @Binding var popUp_V2: Bool
    @Binding var camera: MapCameraPosition
    @Binding var showSearch:Bool
//    @Binding var searchFromPSV: Bool
    //var onSearchPlaces: () -> Void

    // State variable for navigation to EnlargeMpaView_V2
//    @State private var navigateToMapView: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Select Area")) {
                        Picker("Area", selection: $selectedArea) {
                            ForEach(Area.allCases, id: \.self) { area in
                                Text(area.rawValue).tag(area)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: selectedArea) { oldValue, newValue in
                            // if it's not in the new area's districts, reset selected district
                            if !newValue.districts.contains(
                                selectedDistrict ?? District.centralAndWestern)
                            {
                                selectedDistrict = nil
                            }
                        }
                    }

                    Section(header: Text("Select District")) {
                        Picker("District", selection: $selectedDistrict) {
                            ForEach(selectedArea.districts, id: \.self) { district in
                                Text(district.rawValue).tag(district as District?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        // Disable the Picker if no district is selected
                        .disabled(selectedArea.districts.isEmpty)
                    }

                    Section(header: Text("Select Contract type")) {
                        Picker("Contract Type", selection: $selectedContract) {
                            ForEach(ContractType.allCases, id: \.self) { contract in
                                Text(contract.rawValue).tag(contract)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        // Disable the Picker if no district is selected
                        .disabled(selectedArea.districts.isEmpty)
                    }

                    // Display selected values
                    Section(header: Text("Selected Values")) {
                        Text("Area: \(selectedArea.rawValue)")
                        if let district = selectedDistrict {
                            Text("District: \(district.rawValue)")
                        }
                    }
                    Button(action: {
                        searchPlaces()
                        show = false
                        popUp_V2 = false
                        currentMenu = MenuItem(rawValue: selectedContract.rawValue)//this line of code switch to the user's slectedContract EnlargeMpaView_V2.
                        showSearch = false
//                        onSearchPlaces()
                        
                    }) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Search")
                            Spacer()
                        }
                    }
                    .disabled(selectedDistrict == nil)
                }
//

            }
            .navigationTitle("Property Location Selector")
            .navigationBarTitleDisplayMode(.inline)
        }
        .backButton()
//        .alert(errorMessage, isPresented: $showAlert){
//            Button("OK", role: .cancel){}
//        }

    }
    func searchPlaces() {
        CLGeocoder()
            .geocodeAddressString(selectedDistrict!.rawValue, completionHandler: updatePlaces)
    }

    func updatePlaces(placemarks: [CLPlacemark]?, error: Error?) {
        mapItem = nil
        if error != nil {
            print("Geo failed with error: \(error!.localizedDescription)")
            //showAlert = true
        } else if let marks = placemarks, marks.count > 0 {
            placemark = marks[0]
            if let address = placemark!.postalAddress {
                let place = MKPlacemark(
                    coordinate: placemark!.location!.coordinate, postalAddress: address)
                result = "\(address.street), \(address.city), \(address.state), \(address.country)"
                mapItem = MKMapItem(placemark: place)
                mapItem?.name = selectedDistrict!.rawValue
                zoomIntoTheSelectedPlace(searchedLatitude: placemark!.location!.coordinate.latitude, searchedLongitude: placemark!.location!.coordinate.longitude)
            }
        }
    }
    func zoomIntoTheSelectedPlace(searchedLatitude: Double, searchedLongitude: Double) {
        let searchedCoor = CLLocationCoordinate2D(latitude: searchedLatitude, longitude: searchedLongitude)
        
        let searchedRegion = MKCoordinateRegion(center: searchedCoor, latitudinalMeters: 3000, longitudinalMeters: 3000)
        
        camera = .region(searchedRegion)
        }
    
    
}
//
//#Preview {
//    //    pointSearchView(show: .constant(true))
//    pointSearchView(show: .constant(true))
//}
