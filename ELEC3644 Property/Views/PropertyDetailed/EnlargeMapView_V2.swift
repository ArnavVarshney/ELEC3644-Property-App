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
extension CLLocationCoordinate2D{
    static let userLocation = CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694)
}

extension MKCoordinateRegion{
    static let userRegion = MKCoordinateRegion(center: .userLocation, latitudinalMeters: 60000, longitudinalMeters: 60000)
}

struct EnlargeMapView_V2: View {
    @EnvironmentObject var viewModel: PropertyViewModelWithLocation
    @State var camera: MapCameraPosition = .region(.userRegion)
    @State private var showAlert: Bool = false
    @State private var result: String = ""
    @State private var showSearch: Bool = false
    @State private var searchText: String = ""
    @State private var placemark: CLPlacemark?
    @State private var mapItem: MKMapItem?
    @State private var mapSelection: Int?  // to identify which marker has been tapped
    @State private var showLookAroundScene: Bool = false
//    @State var propertyLocations: [String: CLLocationCoordinate2D]
    var body: some View {
        NavigationStack {
            Text(String(viewModel.properties.count))
            Map(position: $camera){
                UserAnnotation()
                
                ForEach(viewModel.properties, id: \.self) { property in
                    if let location = viewModel.getLocation(for: property.name){
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
                        .annotationTitles(.visible)
                    }
                    
                }
                
            }
            .mapControls{
                MapCompass()
                MapUserLocationButton()
                MapScaleView()
            }
            .navigationTitle("Map")
        }
        
    }
    
    //do not change
    func searchPlaces(){
        CLGeocoder().geocodeAddressString(searchText, completionHandler: updatePlaces)
    }
    
    //do not change
    func updatePlaces(placemarks: [CLPlacemark]?, error: Error?){
        mapItem = nil
        if error != nil{
            print("Geo failed with error: \(error!.localizedDescription)")
            showAlert = true
        }else if let marks = placemarks, marks.count>0{
            placemark = marks[0]
            if let address=placemark!.postalAddress {
                let place=MKPlacemark(coordinate: placemark!.location!.coordinate, postalAddress: address)
                result = "\(address.street), \(address.city), \(address.state), \(address.country)"
                mapItem=MKMapItem(placemark: place)
                mapItem?.name=searchText
            
            }
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

