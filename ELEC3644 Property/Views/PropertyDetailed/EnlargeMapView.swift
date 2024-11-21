//
//  EnlargeMapView.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 27/10/2024.
//
import MapKit
import SwiftUI

struct EnlargeMapView: View {
    @EnvironmentObject var viewModel: PropertyDetailViewModel
    @State private var camera: MapCameraPosition = .automatic
    @Binding var showEnlargeMapView: Bool
    @State var mapSelection: MKMapItem?
    @State var showLookAroundScene: Bool = false
    @State var popUp: Bool = true
    @State private var showDirection = false
    @State private var route: MKRoute?
    @State private var showRoute = false
    @State private var routeDestination: MKMapItem?
    @State private var travelDistance: CLLocationDistance?
    @State private var travelTime: TimeInterval?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                // The Map View
                Map(position: $camera, selection: $mapSelection) {
                    // Annotation for the target property
                    Annotation(viewModel.property.name, coordinate: viewModel.location) {
                        HStack {
                            Text(String(viewModel.property.netPrice))
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
                    .annotationTitles(.visible)

                    // Markers for other places
                    ForEach(viewModel.places, id: \.self) { place in
                        if showRoute {
                            if place == routeDestination {
                                Marker(
                                    place.placemark.name ?? "POI",
                                    systemImage: PropertyDetailViewModel.poiIcon(
                                        for: place.pointOfInterestCategory),
                                    coordinate: place.placemark.coordinate
                                )
                                .tag(1)
                                .tint(.blue)
                            }
                        } else {
                            Marker(
                                place.placemark.name ?? "POI",
                                systemImage: PropertyDetailViewModel.poiIcon(
                                    for: place.pointOfInterestCategory),
                                coordinate: place.placemark.coordinate
                            )
                            .tint(.blue)
                        }
                    }

                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 6)
                    }
                }
                .mapControlVisibility(.hidden)
                .sheet(isPresented: $showLookAroundScene) {
                    if let selectedMapItem = mapSelection {
                        GetLookAroundScene(mapItem: selectedMapItem, showDirection: $showDirection)
                            .presentationDetents([.height(300)])
                            .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                            .presentationCornerRadius(25)
                            .interactiveDismissDisabled(true)
                    }
                }

                // Pop-up view and other UI elements
                VStack(alignment: .center) {

                    // Button to reset camera location, reset all buttons/bool
                    HStack {
                        Spacer()  // Pushes the button to the right
                        Button {
                            centerCameraOnUserLocation()
                            popUp = false
                            showLookAroundScene = false
                            showDirection = false
                            route = nil
                            showRoute = false
                            routeDestination = nil
                            mapSelection = nil
                        } label: {
                            Image(systemName: "mappin.and.ellipse.circle.fill")
                                //.foregroundStyle(.black)
                                .background {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 50, height: 50)
                                }
                                .padding(10)  // Add some padding around the button
                        }
                    }
                    .padding(.trailing, 20)
                    Spacer()
                    if popUp {
                        MapPopUpView(property: viewModel.property, popUp: $popUp)
                            .frame(height: 270)
                            .padding(.bottom, 24)
                            .padding(.horizontal, 20)
                    }
                    Button {
                        popUp.toggle()  // Show/Hide the PopUpView
                    } label: {
                        Image(systemName: popUp ? "xmark" : "plus")
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 30, height: 30)
                            }
                            .padding(.bottom)
                    }
                }
            }
            .backButton()
            .onAppear {
                camera = .region(
                    MKCoordinateRegion(
                        center: viewModel.location, latitudinalMeters: 1000,
                        longitudinalMeters: 1000))
            }
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            showLookAroundScene = newValue != nil
            route = nil
            showRoute = false
            routeDestination = nil
            showDirection = false
            popUp = false

        }
        .onChange(
            of: showDirection,
            { oldValue, newValue in
                if newValue {
                    fetchRoute()
                }
            })
    }

    func fetchRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: viewModel.location))
        request.destination = mapSelection
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = mapSelection  //now routeDestination stores the MKMapItem obj of the selected mapItem
            withAnimation(.snappy) {
                showLookAroundScene = false
                if let rect = route?.polyline.boundingMapRect {
                    let showStartDestRect = rect.insetBy(
                        dx: -rect.width * 0.25, dy: -rect.height * 0.25)
                    camera = .rect(showStartDestRect)
                    travelTime = route?.expectedTravelTime
                    travelDistance = route?.distance
//                    print(travelTime)
//                    print(travelDistance)
                    
                }
            }
        }
    }

    func updateCameraPosition() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: viewModel.location))
        request.destination = mapSelection

        Task {
            let result = try? await MKDirections(request: request).calculate()  //create directions object and calculate route
            route = result?.routes.first
            routeDestination = mapSelection
            withAnimation(.snappy) {
                //                showRoute = true  we don't want to display the polyline
                //showLookAroundScene = false  //actually this code is not necessary cuz our showRoute button is not on the GetLookAroundScene View
                if let rect = route?.polyline.boundingMapRect {
                    //ensure the start and dest do not lie on the edge of the monitor
                    let showStartDestRect = rect.insetBy(
                        dx: -rect.width * 0.25, dy: -rect.height * 0.25)
                    camera = .rect(showStartDestRect)
                }
            }
        }

    }

    func centerCameraOnUserLocation() {
        // Get user's current location from locationManager and set camera position accordingly.
        let propertyCoordinate = viewModel.location

        // Create a region centered on the user's current location.
        let userRegion = MKCoordinateRegion(
            center: propertyCoordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)

        // Update camera position to center on user's location.
        camera = .region(userRegion)  // Update view model's position directly
    }
}

#Preview {
    struct EnlargeMapView_Preview: View {
        @StateObject var propertyViewModel = PropertyViewModel()
        @StateObject var propertyDetailViewModel = PropertyDetailViewModel(
            property: Mock.Properties[0])
        @State private var showEnlargeMapView = false

        var body: some View {
            EnlargeMapView(showEnlargeMapView: $showEnlargeMapView)
                .environmentObject(propertyDetailViewModel)
                .environmentObject(propertyViewModel)
                .environmentObject(UserViewModel())
        }
    }
    return EnlargeMapView_Preview()
}
