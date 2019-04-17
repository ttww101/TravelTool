//
//  UserLocationManager.swift
//  TravelNote
//
//  Created by WU CHIH WEI on 2017/4/25.
//  Copyright © 2017年 伍智瑋. All rights reserved.
//

import MapKit
import Foundation

class UserLocationManager {

    func createLocationManagerWith(accuracy: CLLocationAccuracy, filter: CLLocationDistance, delegate: CLLocationManagerDelegate) -> CLLocationManager {

        let locationManager = CLLocationManager()

        locationManager.delegate = delegate

        locationManager.desiredAccuracy = accuracy

        locationManager.requestAlwaysAuthorization()

        locationManager.distanceFilter = filter

        locationManager.startUpdatingLocation()

        return locationManager
    }

    func authorizationStatusHandler(status: CLAuthorizationStatus, completion: () -> Void) {

        switch status {

        case .authorizedAlways, .authorizedWhenInUse:

            break

        case .denied, .notDetermined, .restricted:

            completion()
        }
    }
}
