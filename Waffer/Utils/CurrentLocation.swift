//
//  CurrentLocation.swift
//  Waffer
//
//  Created by Ammar Alfarhan on 2/6/19.
//  Copyright © 2019 Batool Alsumaeel. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocation: CLLocation {
   
    static func userCurrentLocation(completion: @escaping (CLLocation) -> ()) {
        let manager = CLLocationManager()
        guard let location = manager.location else { return }
        completion(location)
    }
    
    static func getUserGeoLocation(_ coordinate: CLLocation, completion: @escaping (String) -> ()) {
        let manager = CLLocationManager()
        guard let location = manager.location else { return }
        let geodecoder = CLGeocoder()
        geodecoder.reverseGeocodeLocation(location, completionHandler: { (placemakers, error) in
            if error != nil {
                print("Fail to reverse location")
                return
            }
            guard let placemaker = placemakers?[0] else { return }
            guard let city = placemaker.locality else { return }
            completion(city)
            
        })
    }
}
