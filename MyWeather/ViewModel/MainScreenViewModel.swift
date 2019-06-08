//
//  MainScreenViewModel.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol MainScreenViewModelDelegate: class {
    func mainScreenViewModelTableViewShouldBeReloaded()
}

class MainScreenViewModel {
    var locationManagerPermissionStatus = LiveDynamicType(PermissionStatus.notDetermined)
    var weatherHeaderViewModel: WeatherHeaderViewModel?
    var generalInfo = LiveDynamicType([GeneralInfoViewModel]())
    weak var delegate: MainScreenViewModelDelegate?
    
    init(delegate: MainScreenViewModelDelegate? = nil) {
        self.delegate = delegate
        LocationManager.sharedInstance.delegate = self
        let locationAuthorizationStatus = LocationManager.sharedInstance.currentAuthorizationStatus()
        self.setLocationAuthorization(locationAuthorizationStatus)
        self.weatherHeaderViewModel = WeatherHeaderViewModel()
        self.delegate?.mainScreenViewModelTableViewShouldBeReloaded()
    }
    
    enum PermissionStatus {
        case requesting, allowed, denied, notDetermined
        
        var message: String {
            switch self {
            case .denied:
                return "You need to turn on Location Service to use this app! Please go to Settings and grant Location permission to MyWeather."
            case .notDetermined:
                return "To view your current location weather you need to give me Location permission."
            default:
                return ""
            }
        }
        
        var actionTitle: String {
            switch self {
            case .denied:
                return "Go to Settings"
            case .notDetermined:
                return "Grant permission"
            default:
                return ""
            }
        }
    }
}

// MARK: - public methods
extension MainScreenViewModel {
    func locationPermissionViewActionPressed() {
        switch self.locationManagerPermissionStatus.value {
        case .notDetermined:
            self.requestLocationAuthorization()
        case .denied:
            self.openSettingsForLocationPermission()
        default:
            break
        }
    }
    
    func setTableViewScroll(yOffset: CGFloat) {
        if yOffset <= 0 {
            self.weatherHeaderViewModel?.set(scrollOffset: yOffset)
        }
    }
    
    func headerCellDidSelected() {
        if self.weatherHeaderViewModel?.errorString.value != nil {
            self.reload()
        }
    }
    
    func reload() {
        self.getUserLocation()
    }
}

// MARK: - private methods
extension MainScreenViewModel {
    private func requestLocationAuthorization() {
        self.locationManagerPermissionStatus.set(to: .requesting)
        LocationManager.sharedInstance.requestPermission()
    }
    
    private func openSettingsForLocationPermission() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl)
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    private func setLocationAuthorization(_ locationAuthorizationStatus: CLAuthorizationStatus) {
        switch locationAuthorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManagerPermissionStatus.set(to: .allowed)
            self.getUserLocation()
        case .denied, .restricted:
            self.locationManagerPermissionStatus.set(to: .denied)
        case .notDetermined:
            self.locationManagerPermissionStatus.set(to: .notDetermined)
        default:
            self.locationManagerPermissionStatus.set(to: .notDetermined)
        }
    }
    
    private func getUserLocation() {
        self.weatherHeaderViewModel?.errorString.set(to: nil)
        self.weatherHeaderViewModel?.isLoading.set(to: true)
        LocationManager.sharedInstance.startLocationUpdate()
    }
    
    private func startLoadingForecast(for location: CLLocationCoordinate2D) {
        self.generalInfo.set(to: [])
        self.weatherHeaderViewModel?.isLoading.set(to: true)
        WebServiceManager.getWeatherForecast(for: location) { (forecast, error) in
            self.weatherHeaderViewModel?.isLoading.set(to: false)
            if let forecast = forecast {
                self.set(forecast: forecast)
            } else {
                self.weatherHeaderViewModel?.errorString.set(to: error)
            }
        }
    }
    
    private func set(forecast: WeatherForecast) {
        var generalInfo = [GeneralInfoViewModel]()
        if let precipIntensity = forecast.precipIntensity {
            generalInfo.append(.init(title: "Precipitation Intensity", content: "\(precipIntensity) mm/h"))
        }
        if let precipProbability = forecast.precipProbability {
            generalInfo.append(.init(title: "Precipitation Probability", content: "\(Int(precipProbability * 100))%"))
        }
        if let temperature = forecast.temperature {
            generalInfo.append(.init(title: "Temperature", content: "\(temperature) Fahrenheit"))
        }
        if let humidity = forecast.humidity {
            generalInfo.append(.init(title: "Humidity", content: "\(Int(humidity * 100))%"))
        }
        if let pressure = forecast.pressure {
            generalInfo.append(.init(title: "Pressure", content: "\(pressure) millibars"))
        }
        if let windSpeed = forecast.windSpeed {
            generalInfo.append(.init(title: "Wind Speed", content: "\(windSpeed) mph"))
        }
        if let windGust = forecast.windGust {
            generalInfo.append(.init(title: "Wind Gust", content: "\(windGust) mph"))
        }
        if let windBearing = forecast.windBearing {
            generalInfo.append(.init(title: "Wind Bearing", content: "\(windBearing)°"))
        }
        if let cloudCover = forecast.cloudCover {
            generalInfo.append(.init(title: "Cloud Cover", content: "\(Int(cloudCover * 100))%"))
        }
        if let uvIndex = forecast.uvIndex {
            generalInfo.append(.init(title: "UV Index", content: "\(uvIndex)"))
        }
        if let visibility = forecast.visibility {
            generalInfo.append(.init(title: "Visibility", content: "\(visibility) miles"))
        }
        if let ozone = forecast.ozone {
            generalInfo.append(.init(title: "Ozone", content: "\(ozone)"))
        }
        self.generalInfo.set(to: generalInfo)
        
        self.weatherHeaderViewModel?.timeZoneName.set(to: forecast.timeZoneName)
        self.weatherHeaderViewModel?.time.set(to: forecast.time)
        self.weatherHeaderViewModel?.weatherSummary.set(to: forecast.summary)
        
        var backgroundColor: UIColor = .white
        let summary = forecast.summary.lowercased()
        if summary.contains("cloud") {
            backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else if summary.contains("clear") {
            backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else if summary.contains("rain") || summary.contains("snow") {
            backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        self.weatherHeaderViewModel?.backgroundColor.set(to: backgroundColor)
    }
}

// MARK: - LocationManagerDelegate
extension MainScreenViewModel: LocationManagerDelegate {
    func locationManager(didChange authorization: CLAuthorizationStatus) {
        self.setLocationAuthorization(authorization)
    }
    
    func locationManager(didReceive location: CLLocation?, with error: Error?) {
        LocationManager.sharedInstance.stopLocationUpdate()
        self.weatherHeaderViewModel?.isLoading.set(to: false)
        if let location = location {
            self.startLoadingForecast(for: location.coordinate)
        } else {
            self.weatherHeaderViewModel?.errorString.set(to: error?.localizedDescription ?? "Error in getting location")
        }
    }
}
