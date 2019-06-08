//
//  LocationManager.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(didReceive location: CLLocation?, with error: Error?)
    func locationManager(didChange authorization: CLAuthorizationStatus)
}

class LocationManager: NSObject {
    static let sharedInstance = LocationManager()
    
    private var hasReported = false
    private var manager: CLLocationManager
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.delegate = self
    }
}

// MARK: - public methods
extension LocationManager {
    func requestPermission() {
        self.manager.requestWhenInUseAuthorization()
    }
    
    func currentAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func startLocationUpdate() {
        self.hasReported = false
        self.manager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        self.manager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.locationManager(didReceive: locations.sorted(by: { $0.timestamp > $1.timestamp }).first, with: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !self.hasReported {
            self.hasReported = true
            self.delegate?.locationManager(didReceive: nil, with: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.locationManager(didChange: status)
    }
}
