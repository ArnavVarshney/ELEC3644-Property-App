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
extension CLLocationCoordinate2D {
    static let userLocation = CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)
}

extension MKCoordinateRegion {
    static let userRegion = MKCoordinateRegion(
        center: .userLocation, latitudinalMeters: 60000, longitudinalMeters: 60000)
}

struct EnlargeMapView_V2: View {
    @EnvironmentObject var viewModel: PropertyViewModelWithLocation
    @Binding var currentMenu: MenuItem?
    @State var camera: MapCameraPosition = .region(.userRegion)
    @State private var showAlert: Bool = false
    @State private var result: String = ""
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    @State private var placemark: CLPlacemark?
    @State private var mapItem: MKMapItem?
    @State private var mapSelection: Int?  // to identify which marker has been tapped   //for search marker, implement it later
    @State private var selectedPropertyId: UUID?  //only specified for the popUpView
    @State private var propertySelection: UUID?  //for propertySelection using viewModel.propertyMapItems (that is a dict)
    @State var popUp_V2: Bool = true
    @State private var showLookAroundScene: Bool = false
    @State private var propertyMapItem: MKMapItem?

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
                }
                .mapControls {
                    MapCompass()
                    MapUserLocationButton()
                    MapScaleView()
                }
                //                .sheet(isPresented: $showLookAroundScene){
                //                    if let selectedPropertyId = propertySelection, let selectedProperty = viewModel.properties.first(where: { $0.id == selectedPropertyId }){
                //                        propertyMapItem = viewModel.getMapItem(for: selectedProperty.name) // Assign property map item
                //                        GetLookAroundScene(mapItem: propertyMapItem!)
                //                            .presentationDetents([.height(300)])
                //                            .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                //                            .presentationCornerRadius(25)
                //                            .interactiveDismissDisabled(true)
                //                    }
                //                }

                VStack(alignment: .center) {

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
                            //
                            //                            Button(action: {
                            //                                showLookAroundScene.toggle()
                            //                            }) {
                            //                                HStack {
                            //                                    Image(systemName: "eyes")
                            //                                        // Use a globe symbol or any other relevant icon
                            //                                        .resizable()
                            //                                        .scaledToFit()
                            //                                        .frame(width: 40, height: 40)
                            //                                        .padding()
                            //
                            //                                    Text("Look around scene")
                            //                                }
                            //                                .background(Color.blue.opacity(0.7))  // Customize your color
                            //                                .foregroundColor(.white)
                            //                                .shadow(radius: 5)  // Add shadow for
                            //                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)  // Use inline mode
            .toolbar {
                ToolbarItem(placement: .principal) {
                    //                    if currentMenu?.rawValue == "Buy"{
                    //                        Text(
                    //                            "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties on sale"
                    //                        )
                    //                    }else if currentMenu?.rawValue == "Rent"{
                    //                       Text( "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties for rent")
                    //                    }else if currentMenu?.rawValue == "Lease"{
                    //                        Text( "\(viewModel.getByContractType(contractType: currentMenu!.rawValue).count) properties for lease")
                    //                    }
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
        }
        .backButton()
        .onChange(of: mapSelection) { oldValue, newValue in
            showLookAroundScene = newValue != nil
            print(showLookAroundScene)
        }

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
