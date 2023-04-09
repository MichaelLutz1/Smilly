//
//  LocationManager.swift
//  Smilly
//
//  Created by Michael Lutz on 4/8/23.
//

import Foundation
import CoreLocation
import MapKit

class LocationDataManager: NSObject, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var pendingRating = 0
    override init(){
        super.init()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
        
            
    func locationManagerDidChangeAuth(_ manager: CLLocationManager){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        switch manager.authorizationStatus{
            case .authorizedWhenInUse:
                    break
            case .restricted, .denied, .notDetermined:
                manager.requestWhenInUseAuthorization()
                break
            default:
                break
            }
    }
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
        //submit post request here using pending rating, lat, long, and age of 0
    ){
        var report:Report = Report(rating: String(format:"%lf", pendingRating),
                                   age: "0",
                                   lat: String(format:"%lf", locations[0].coordinate.latitude),
                                   long: String(format:"%lf", locations[0].coordinate.longitude) )
        
        
        for location in locations{
            print(location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error){
        print("error")
    }
    func submitRating(rating: Int){
        locationManager.requestLocation()
        pendingRating = rating
        
    }
    
    struct Report: Codable{
        var rating: String
        var age: String
        var lat: String
        var long: String
    }
}
