//
//  LocationManager.swift
//  UserCurrentLocation
//
//  Created by Mak Yilam on 8/11/2024.
//

import CoreLocation
import Foundation
import MapKit

//delegate
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {

    private let locationManager = CLLocationManager()  //Master
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.283, longitude: 114.137),
        latitudinalMeters: 300, longitudinalMeters: 300)

    //var distance:CLLocationDistance = destLocation.distance(from: )

    override init() {
        super.init()
        locationManager.delegate = self  //assign the delegate and ask for the permission
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        region.center.latitude = locations[0].coordinate.latitude
        region.center.longitude = locations[0].coordinate.longitude
        //when the current location is updated, the region center will change to the current location centre. Therefore technically speaking, current user location should be keep on at the map center.
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways
            || locationManager.authorizationStatus == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()  //start tracking the user's current location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    //the three funcs above are called by the master locationManager, which it is a CLLocationManager(). We dont need to call them.
}
