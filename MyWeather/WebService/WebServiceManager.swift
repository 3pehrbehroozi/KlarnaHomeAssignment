//
//  WebServiceManager.swift
//  MyWeather
//
//  Created by Sepehr Behroozi on 6/8/19.
//  Copyright © 2019 sepehr. All rights reserved.
//

import UIKit
import CoreLocation

class WebServiceManager {
    class func getWeatherForecast(for location: CLLocationCoordinate2D, _ completionHandler: @escaping (_ result: WeatherForecast?, _ error: String?) -> Void) {
        let urlString = "https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/\(location.latitude),\(location.longitude)"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        self.send(request: request as URLRequest) { (responseObject, errorString) in
            DispatchQueue.main.async {
                completionHandler(WeatherForecast.from(json: responseObject), errorString)
            }
        }
    }
    
    fileprivate class func send(request: URLRequest, _ completionHandler: @escaping (_ response: JSONObject?, _ error: String?) -> Void) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            //accept all 20x codes
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode / 10 == 20, let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject {
                completionHandler(jsonObject, nil)
            } else {
                completionHandler(nil, error?.localizedDescription ?? "Error connecting to weather service")
            }
        }.resume()
    }
}
