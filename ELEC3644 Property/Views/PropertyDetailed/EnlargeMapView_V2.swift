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
        MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
    }
}

extension CLLocationCoordinate2D {
    static let userLocation = CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)
}

extension MKCoordinateRegion {
    static let userRegion = MKCoordinateRegion(
        center: .userLocation, latitudinalMeters: 60000, longitudinalMeters: 60000)
}

struct EnlargeMapView_V2: View {
    @EnvironmentObject var viewModel: PropertyViewModel
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
                                        .foregroundColor(Color.black)
                                    Text("HKD")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
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
                    MapScaleView()
                }

                VStack(alignment: .center) {
                    SearchAndFilterBarView(searchText: $searchText, isActive: $showpointSearchView)
                    {
                        print("Search submitted with text: \(searchText)")  // Check if this line executes
                        Task {
                            guard !searchText.isEmpty else { return }
                            searchPlaces()
                        }
                    }
                    //                        .onTapGesture {
                    //                            withAnimation(.snappy) {
                    //                                showpointSearchView.toggle()
                    //                            }
                    //                        }
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
                        .foregroundColor(.black)
                        .padding()
                    } else if currentMenu!.rawValue == "Rent" {
                        Text(
                            "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties for rent"
                        )
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding()
                    } else if currentMenu!.rawValue == "Lease" {
                        Text(
                            "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties for lease"
                        )
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding()
                    }

                }
            }
            .sheet(isPresented: $showpointSearchView) {
                //pointSearchView(show: $showpointSearchView, currentMenu: $currentMenu, mapItem: $mapItem, placemark: $placemark)
                pointSearchView(
                    show: $showpointSearchView, currentMenu: $currentMenu, mapItem: $mapItem,
                    popUp_V2: $popUp_V2, camera: $camera, showSearch: $showSearch
                )
                //                {
                //                    searchPlaces()
                //                }
                .presentationDetents([.height(550)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(550)))
                .presentationCornerRadius(24)
                //.interactiveDismissDisabled(true)
            }
        }
        //.backButton().background(ignoresSafeAreaEdges: .top)
        //        .onChange(of: mapSelection) { oldValue, newValue in
        //            showLookAroundScene = newValue != nil
        //            print(showLookAroundScene)
        //        }
        .onSubmit(of: .search) {
            Task {
                guard !searchText.isEmpty else { return }
                searchPlaces()
                showSearch = false

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
                zoomIntoTheSelectedPlace(
                    searchedLatitude: placemark!.location!.coordinate.latitude,
                    searchedLongitude: placemark!.location!.coordinate.longitude)
            }
        }
    }

    func zoomIntoTheSelectedPlace(searchedLatitude: Double, searchedLongitude: Double) {
        let searchedCoor = CLLocationCoordinate2D(
            latitude: searchedLatitude, longitude: searchedLongitude)

        let searchedRegion = MKCoordinateRegion(
            center: searchedCoor, latitudinalMeters: 3000, longitudinalMeters: 3000)

        camera = .region(searchedRegion)
    }

}

//#Preview {
//    EnlargeMapView_V2()
//}
//
//#Preview {
//    struct EnlargeMapView_V2_Preview: View {
//        @StateObject var propertyViewModelWithLocation = PropertyViewModelWithLocation()
//        @StateObject var propertyViewModel = PropertyViewModel()
//        @StateObject var propertyDetailViewModel = PropertyDetailViewModel(
//            property: Mock.Properties[0])
//        @State private var showEnlargeMapView = false
//        var body: some View {
//            EnlargeMapView(showEnlargeMapView: $showEnlargeMapView)
//                .environmentObject(propertyDetailViewModel)
//                .environmentObject(propertyViewModel)
//                .environmentObject(UserViewModel())
//                .environmentObject(PropertyViewModelWithLocation)
//        }
//    }
//    return EnlargeMapView_V2_Preview()
//}
