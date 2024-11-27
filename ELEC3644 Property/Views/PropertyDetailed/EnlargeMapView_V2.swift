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

//the center of HK cuz this property app should only be available in HK. The Default camera location. Will update the camera when user press the location button

enum StartMapCameraLocation {  //for pointSearchView
    case userLocation
    case customLocation(latitude: Double, longitude: Double)

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .userLocation:
            return .userLocation
        case .customLocation(let latitude, let longitude):
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

extension CLLocationCoordinate2D {
    static let userLocation = CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)
}

extension MKCoordinateRegion {
    static let userRegion = MKCoordinateRegion(
        center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
}

struct EnlargeMapView_V2: View {
    @EnvironmentObject var viewModel: PropertyViewModel
    @EnvironmentObject var mapSettingsViewModel: MapSettingsViewModel
    @Binding var currentMenu: MenuItem?
    @State var camera: MapCameraPosition = .region(.userRegion)
    @State private var showAlert: Bool = false
    @State private var showSearch: Bool = false
    @State private var result: String = ""
    @State private var searchText: String = ""
    @State private var placemark: CLPlacemark?
    @State private var mapItem: MKMapItem?
    @State private var mapSelection: Int?  // to identify which marker has been tapped   //for search marker, implement it later
    @State private var errorMessage = "Place not found!"
    @State private var selectedPropertyId: UUID?  //only specified for the popUpView
    @State private var propertySelection: UUID?  //for propertySelection using viewModel.propertyMapItems (that is a dict)
    @State var popUp_V2: Bool = true
    //@State private var showLookAroundScene: Bool = false
    @State private var propertyMapItem: MKMapItem?
    //    @State var searchFromPSV: Bool = false

    @State private var showpointSearchView = false

    // Zoom level state
    @State private var zoomLevel: Double = 10000  // Default zoom level
    @State private var addedLatitude: Double = 0.0  // Default additional latitude
    @State private var addedLongitude: Double = 0.0  // Default additional longitude
//    @State private var newLatitude: Double = 0.0
//    @State private var newLongitude: Double = 0.0
    @State private var newCameraCenterLocation: CLLocationCoordinate2D?
    @State private var newCameraRect: CLLocationCoordinate2D?
    @State private var newCameraRegion: CLLocationCoordinate2D?

    // Accepting a PropertyLocation enum as a parameter
    var startMapCameraLocation: StartMapCameraLocation

    init(currentMenu: Binding<MenuItem?>, startMapCameraLocation: StartMapCameraLocation) {
        self._currentMenu = currentMenu
        self.startMapCameraLocation = startMapCameraLocation
        self._camera = State(initialValue: .region(startMapCameraLocation.region))  // Initialize camera based on location
    }

    //    @State var propertyLocations: [String: CLLocationCoordinate2D]
    var body: some View {
        NavigationStack {
            //Text(String(viewModel.properties.count))
            ZStack {
                Map(position: $camera, selection: $propertySelection) {
                    //UserAnnotation()
                    ForEach(
                        viewModel.getByContractType(contractType: currentMenu!.rawValue), id: \.self
                    ) { property in  //select either buy, rent or lease
                        if let location = viewModel.getLocation(for: property.name) {
                            //                            propertyMapItem = viewModel.getMapItem(for: property.id)
                            Annotation(property.name, coordinate: location) {
                                HStack {
                                    Text(String(property.netPrice))
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.neutral100)
                                    Text("HKD")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.neutral100)
                                }
                                .frame(width: 125, height: 25)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    Capsule()
                                        .stroke(lineWidth: 0.5)
                                        .foregroundColor(.white)
                                        .addShadow()
                                        .clipShape(RoundedRectangle(cornerRadius: 1))
                                )
                            }
                            .tag(property.id)  // Set the tag for selection  !!!!!!!!!! Very Important, take me a while to find this bug. Or else, propertySelection will always be zero because user can select nothing by pressing property price bubble
                            .annotationTitles(.visible)
                        }
                    }
                    
                    if let item = mapItem {
                        Marker(item: item)
                            .tint(.red)
                    }
                }
                .mapControls {
                    MapCompass()
                    MapUserLocationButton()
                    MapPitchToggle()
                    MapScaleView()
                }
                .onMapCameraChange(frequency: .onEnd) { context in
                    print(context.camera)
                    print("AAAAAAA   \(context.camera.centerCoordinate)     AAAAAAA")
                    newCameraCenterLocation = context.camera.centerCoordinate
//                    newCameraRect = context.rect
//                    newCameraRegion = context.region
                    print(newCameraCenterLocation)
                    print(context.region)
                    //print(context.rect)
                    print("?????????/")
                    print(camera.region)
                }
                // Zoom and Pan Controls
                HStack(spacing: 20) {
                    Spacer()
                    if mapSettingsViewModel.mapZoomEnabled == true
                        && mapSettingsViewModel.mapPanEnabled == false
                    {
                        VStack {
                            Button(action: {
                                zoomIn()
                                setCameraZoom(latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "plus")
                                    .padding(20)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                zoomOut()
                                setCameraZoom(latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "minus")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Spacer()

                        }
                        .padding(.top, 105)
                    } else if mapSettingsViewModel.mapPanEnabled == true
                        && mapSettingsViewModel.mapZoomEnabled == false
                    {
                        VStack {
                            Button(action: {
                                panUp()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.up")
                                    .padding(20)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panDown()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.down")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panLeft()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.left")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panRight()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.right")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Spacer()

                        }
                        .padding(.top, 105)
                    } else if mapSettingsViewModel.mapPanEnabled == true
                        && mapSettingsViewModel.mapZoomEnabled == true
                    {

                        VStack {
                            Button(action: {
                                zoomIn()
                                setCameraZoom(latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "plus")
                                    .padding(20)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                zoomOut()
                                setCameraZoom(latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "minus")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panUp()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.up")
                                    .padding(20)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panDown()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.down")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panLeft()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.left")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                panRight()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.right")
                                    .padding(25)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                            }
                            Spacer()

                        }
                        .padding(.top, 105)
                    }
                }
                .padding(5)

                VStack(alignment: .center) {
                    //                    SearchAndFilterBarView(searchText: $searchText, isActive: $showpointSearchView)
                    Spacer()  // Pushes content down from the top
                    if popUp_V2, let selectedPropertyId = propertySelection,
                        let selectedProperty = viewModel.properties.first(where: {
                            $0.id == selectedPropertyId
                        })
                    {
                        ZStack {
                            NavigationLink(
                                destination: PropertyDetailView(property: selectedProperty)
                            ) {
                                MapPopUpView(property: selectedProperty, popUp: $popUp_V2)
                                    .frame(height: 270)
                                    .padding(.bottom, 35)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, isPresented: $showSearch)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)  // Use inline mode
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if currentMenu!.rawValue == "Buy" {
                        Text(
                            "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties on sale"
                        )
                        .font(.caption)
                        .foregroundColor(.neutral100)
                        .padding()
                    } else if currentMenu!.rawValue == "Rent" {
                        Text(
                            "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties for rent"
                        )
                        .font(.caption)
                        .foregroundColor(.neutral100)
                        .padding()
                    } else if currentMenu!.rawValue == "Lease" {
                        Text(
                            "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties for lease"
                        )
                        .font(.caption)
                        .foregroundColor(.neutral100)
                        .padding()
                    }

                }
            }
        }
        .backButton()
        .onSubmit(of: .search) {
            Task {
                guard !searchText.isEmpty else { return }
                searchPlaces()
                showSearch = false
//                newCameraCenterLocation = mapItem!.placemark.coordinate
//                setCameraPan()
            }
        }
        .alert(errorMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: showSearch) {
            if !showSearch {
                mapItem = nil
                camera = .region(.userRegion)

            }
        }
        .toolbar(.hidden, for: .tabBar)
    }

    func searchPlaces() {
        CLGeocoder()
            .geocodeAddressString(searchText, completionHandler: updatePlaces)
    }

    func updatePlaces(placemarks: [CLPlacemark]?, error: Error?) {
        mapItem = nil
        if error != nil {
            print("Geo failed with error: \(error!.localizedDescription)")
            showAlert = true
        } else if let marks = placemarks, marks.count > 0 {
            placemark = marks[0]
            if let address = placemark!.postalAddress {
                let place = MKPlacemark(
                    coordinate: placemark!.location!.coordinate, postalAddress: address)
                result = "\(address.street), \(address.city), \(address.state), \(address.country)"
                mapItem = MKMapItem(placemark: place)
                mapItem?.name = searchText
                zoomIntoTheSelectedPlace()
            }
        }
    }

    func zoomIn() {
        if zoomLevel > 500 {  // Prevent zooming in too much
            zoomLevel /= 2  // Zoom in by halving the current level
        }
    }

    func zoomOut() {
        if zoomLevel < 600000 {  // Prevent zooming out too much
            zoomLevel *= 2  // Zoom out by doubling the current level
        }
    }

    func panUp() {
        newCameraCenterLocation?.latitude += 0.005
        addedLatitude += 0.005
    }

    func panDown() {
        newCameraCenterLocation?.latitude -= 0.005
        addedLatitude -= 0.005
    }

    func panLeft() {
        newCameraCenterLocation?.longitude -= 0.005
        addedLongitude -= 0.005
    }

    func panRight() {
        newCameraCenterLocation?.longitude += 0.005
        addedLongitude += 0.005
    }

    func setCameraPan() {
        let currentCenter = newCameraCenterLocation
        let newRegion = MKCoordinateRegion(
            center: currentCenter!,
            latitudinalMeters: zoomLevel,
            longitudinalMeters: zoomLevel)
        camera = .region(newRegion)
        //        }
        //        print("\(camera.region?.center)")  //idk why when the user swipe the map then back using the buttons, the code collapses
    }
    //    func zoomIntoTheSelectedPlace(searchedLatitude: Double, searchedLongitude: Double) {
    func zoomIntoTheSelectedPlace() {
        //setCameraZoom(latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
        if placemark != nil {
            let searchedCoor = CLLocationCoordinate2D(
                latitude: placemark!.location!.coordinate.latitude,
                longitude: placemark!.location!.coordinate.longitude)

            let searchedRegion = MKCoordinateRegion(
                center: searchedCoor, latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)

            camera = .region(searchedRegion)
        } else {
            setCameraZoom(latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
        }
    }

    func setCameraZoom(
        latitudinalMeters: CLLocationDistance, longitudinalMeters: CLLocationDistance
    ) {
        let currentCenter = newCameraCenterLocation
        let newRegion = MKCoordinateRegion(
            center: currentCenter!,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters)
        camera = .region(newRegion)
        //        }
        //        print("\(camera.region?.center)")  //idk why when the user swipe the map then back using the buttons, the code collapses
    }

}

//#Preview {
//    struct EnlargeMapView_V2_Preview: View {
//        @StateObject var propertyViewModel = PropertyViewModel()
//        @StateObject var propertyDetailViewModel = PropertyDetailViewModel(
//            property: Mock.Properties[0])
//        @State private var showEnlargeMapView = false
//        @Binding var currentMenu: MenuItem?
//        // Accepting a PropertyLocation enum as a parameter
//        var startMapCameraLocation: StartMapCameraLocation
//        
//        var body: some View {
//            EnlargeMapView_V2(currentMenu: $currentMeunu, startMapCameraLocation: startMapCameraLocation)
////                .environmentObject(propertyDetailViewModel)
//                .environmentObject(propertyViewModel)
////                .environmentObject(UserViewModel())
//                .environmentObject(MapSettingsViewModel())
//        }
//    }
//    return EnlargeMapView_V2_Preview()
//}
