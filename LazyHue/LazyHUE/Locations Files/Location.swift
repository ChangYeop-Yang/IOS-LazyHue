//
//  Location.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 7..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import CoreLocation

public class Location: NSObject {
    
    // MARK: - Variable
    public static let locationInstance: Location = Location()
    public var currentLocation: CLLocation?
    public var currentAddress: String = ""
    public let locationGruop: DispatchGroup = DispatchGroup()
    private var locationManager: CLLocationManager = CLLocationManager()
    
    // MARK: - Method
    private override init() {}
    final public func startLocation() {
        
        locationGruop.enter()
        DispatchQueue.main.async(group: locationGruop, execute: { [unowned self] in
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        })
    }
    final public func getCurrentAddress(group: DispatchGroup) {
        
        let geoCoder: CLGeocoder = CLGeocoder()
        
        group.enter()
        self.currentAddress = ""
        DispatchQueue.global(qos: .userInitiated).async(group: group, execute: { [unowned self] in
            
            if let location: CLLocation = self.currentLocation {
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
                    guard error == nil, let place = placemark?.first else {
                        group.leave()
                        fatalError("Error, Convert GEO Location.")
                    }
                    
                    if let administrativeArea: String = place.administrativeArea    { self.currentAddress.append(administrativeArea + " ") }
                    if let locality:           String = place.locality              { self.currentAddress.append(locality + " ") }
                    if let subLocality:        String = place.subLocality           { self.currentAddress.append(subLocality + " ") }
                    if let subThoroughfare:    String = place.subThoroughfare       { self.currentAddress.append(subThoroughfare + " ") }
                    
                    print("- Current Address: \(String(describing: self.currentAddress))")
                    group.leave()
                })
            }
        })
    }
}

// MARK: - CLLocationManagerDelegate
extension Location: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0, let location: CLLocation = locations.last {
            if location.horizontalAccuracy < 100 {
                currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                locationGruop.leave()
                locationManager.stopUpdatingLocation()
            }
        }
    }
}
