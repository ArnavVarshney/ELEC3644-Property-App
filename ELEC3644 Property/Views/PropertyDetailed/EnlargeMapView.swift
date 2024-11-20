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

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                // The Map View
                Map(position: $viewModel.position, selection: $mapSelection) {
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
                        Marker(
                            place.placemark.name ?? "POI",
                            systemImage: PropertyDetailViewModel.poiIcon(
                                for: place.pointOfInterestCategory),
                            coordinate: place.placemark.coordinate
                        )
                    }
                }
                .mapControlVisibility(.hidden)
                .sheet(isPresented: $showLookAroundScene) {
                    if let selectedMapItem = mapSelection {
                        GetLookAroundScene(mapItem: selectedMapItem)
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
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            showLookAroundScene = newValue != nil
        }
    }

    func centerCameraOnUserLocation() {
        // Get user's current location from locationManager and set camera position accordingly.
        let propertyCoordinate = viewModel.location

        // Create a region centered on the user's current location.
        let userRegion = MKCoordinateRegion(
            center: propertyCoordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)

        // Update camera position to center on user's location.
        viewModel.position = .region(userRegion)  // Update view model's position directly
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
