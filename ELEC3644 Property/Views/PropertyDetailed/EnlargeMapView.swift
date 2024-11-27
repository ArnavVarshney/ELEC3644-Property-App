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
    @EnvironmentObject var mapSettingsViewModel: MapSettingsViewModel
    @State private var camera: MapCameraPosition = .automatic
    @Binding var showEnlargeMapView: Bool
    @State var mapSelection: MKMapItem?
    @State var showLookAroundScene: Bool = false
    @State var popUp: Bool = false
    @State private var showDirection = false
    @State private var route: MKRoute?
    @State private var showRoute = false
    @State private var routeDestination: MKMapItem?
    @State private var travelDistance: CLLocationDistance?
    @State private var travelTime: TimeInterval?
    @State private var newCameraCenterLocation: CLLocationCoordinate2D?
    @State private var zoomLevel: Double = 1500  // Default zoom level
    @State private var addedLatitude: Double = 0.0  // Default additional latitude
    @State private var addedLongitude: Double = 0.0  // Default
    @State private var showTravelInformation: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                // The Map View
                Map(position: $camera, selection: $mapSelection) {
                    Marker(
                        coordinate: viewModel.location,
                        label: {
                            VStack {
                                Image(systemName: "building")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)  // Larger size for building marker
                                    .padding(.all, 8)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())

                                Text(String(viewModel.property.name))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.neutral100)
                            }
                        }
                    )

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
                .mapControls {
                    MapCompass()
                    MapUserLocationButton()
                    MapPitchToggle()
                    MapScaleView()
                }
                VStack {
                    // Display travel information
                    if showTravelInformation {
                        if let distance = travelDistance, let time = travelTime {
                            VStack {
                                Spacer()
                                HStack {
                                    Text(
                                        "Distance: \(String(format: "%.1f", distance / 1000)) km"
                                    )  // Convert meters to kilometers
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(5)

                                    Text("Time: \(String(format: "%.0f", time / 60)) min")  // Convert seconds to minutes
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(5)
                                }
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .cornerRadius(10)
                                .padding(.bottom, 50)  // Adjust as needed for spacing from bottom
                            }
                        }
                    }
                }

                .onMapCameraChange(frequency: .onEnd) { context in
                    newCameraCenterLocation = context.camera.centerCoordinate
                }
                .mapControlVisibility(.visible)
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
                        VStack {
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
                                Image(systemName: "mappin.and.ellipse.circle")
                                    .foregroundStyle(.black)
                                    .padding(20)
                                    .frame(width: 45, height: 45)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(8)
                                    .padding(.trailing, 5)  // Add some padding around the button
                            }
                        }
                    }
                    .padding(.top, 115)

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
                            .foregroundStyle(.neutral100)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 30, height: 30)
                            }
                            .padding(.bottom)
                    }
                }
                HStack(spacing: 20) {
                    Spacer()
                    if mapSettingsViewModel.mapZoomEnabled == true
                        && mapSettingsViewModel.mapPanEnabled == false
                    {
                        VStack {
                            Button(action: {
                                zoomIn()
                                setCameraZoom(
                                    latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "plus")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {
                                zoomOut()
                                setCameraZoom(
                                    latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "minus")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Spacer()

                        }
                        .padding(.top, 163)
                    } else if mapSettingsViewModel.mapPanEnabled == true
                        && mapSettingsViewModel.mapZoomEnabled == false
                    {
                        VStack {
                            Button(action: {

                            }) {
                                Image(systemName: "chevron.up")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {

                            }) {
                                Image(systemName: "chevron.down")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {

                            }) {
                                Image(systemName: "chevron.left")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {

                            }) {
                                Image(systemName: "chevron.right")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Spacer()

                        }
                        .padding(.top, 163)
                    } else if mapSettingsViewModel.mapPanEnabled == true
                        && mapSettingsViewModel.mapZoomEnabled == true
                    {

                        VStack {
                            Button(action: {
                                zoomIn()
                                setCameraZoom(
                                    latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "plus")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {
                                zoomOut()
                                setCameraZoom(
                                    latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
                            }) {
                                Image(systemName: "minus")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {
                                panUp()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.up")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {
                                panDown()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.down")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {
                                panLeft()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.left")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Button(action: {
                                panRight()
                                setCameraPan()
                            }) {
                                Image(systemName: "chevron.right")
                                    .padding(15)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .foregroundColor(.neutral100)
                                    .cornerRadius(6)
                            }
                            Spacer()

                        }
                        .padding(.top, 163)
                    }
                }
                .padding(5)

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
            showTravelInformation = false

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

                    // Assign travel time and distance
                    travelTime = route?.expectedTravelTime
                    travelDistance = route?.distance
                    showTravelInformation = true

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

    func zoomIn() {
        if zoomLevel > 250 {  // Prevent zooming in too much
            zoomLevel /= 1.5  // Zoom in by halving the current level
        }
    }

    func zoomOut() {
        if zoomLevel < 600000 {  // Prevent zooming out too much
            zoomLevel *= 1.5  // Zoom out by doubling the current level
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
    }
}

#Preview {
    struct EnlargeMapView_Preview: View {
        @StateObject var propertyViewModel = PropertyViewModel()
        @StateObject var propertyDetailViewModel = PropertyDetailViewModel(
            property: Mock.Properties[0])
        @StateObject var mapSettingsViewModel = MapSettingsViewModel()
        @State private var showEnlargeMapView = false

        var body: some View {
            EnlargeMapView(showEnlargeMapView: $showEnlargeMapView)
                .environmentObject(propertyDetailViewModel)
                .environmentObject(propertyViewModel)
                .environmentObject(UserViewModel())
                .environmentObject(mapSettingsViewModel)
        }
    }
    return EnlargeMapView_Preview()
}
