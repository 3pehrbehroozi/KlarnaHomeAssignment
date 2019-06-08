//
//  WeatherForecast.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import Foundation

class WeatherForecast {
    var time: Date?
    var timeZoneName = ""
    var summary = ""
    var precipIntensity: Double?
    var precipProbability: Double?
    var temperature: Double?
    var humidity: Double?
    var pressure: Double?
    var windSpeed: Double?
    var windGust: Double?
    var windBearing: Double?
    var cloudCover: Double?
    var uvIndex: Double?
    var visibility: Double?
    var ozone: Double?
    
    class func from(json object: JSONObject?) -> WeatherForecast? {
        guard let object = object else {
            return nil
        }
        let result = WeatherForecast()
        
        result.timeZoneName = (object["timezone"] as? String) ?? "Unknown"
        if let currentlyObject = object["currently"] as? JSONObject {
            if let timestamp = currentlyObject["time"] as? TimeInterval {
                result.time = Date(timeIntervalSince1970: timestamp)
            }
            result.summary = (currentlyObject["summary"] as? String) ?? "Unknown"
            result.precipIntensity = currentlyObject["precipIntensity"] as? Double
            result.precipProbability = currentlyObject["precipProbability"] as? Double
            result.temperature = currentlyObject["temperature"] as? Double
            result.humidity = currentlyObject["humidity"] as? Double
            result.pressure = currentlyObject["pressure"] as? Double
            result.windSpeed = currentlyObject["windSpeed"] as? Double
            result.windGust = currentlyObject["windGust"] as? Double
            result.windBearing = currentlyObject["windBearing"] as? Double
            result.cloudCover = currentlyObject["cloudCover"] as? Double
            result.uvIndex = currentlyObject["uvIndex"] as? Double
            result.visibility = currentlyObject["visibility"] as? Double
            result.ozone = currentlyObject["ozone"] as? Double
        }
        
        return result
    }
}
