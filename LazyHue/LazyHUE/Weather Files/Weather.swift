//
//  Weather.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 11..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import Alamofire
import CoreLocation

public class Weather: NSObject {
    
    // MARK: - Variables
    public static let weatherInstance: Weather = Weather()
    public var weatherData: (temperature: Double, humidity: Double, visibility: Double, ozone: Double, sky: String, icon: String) = (0.0, 0.0, 0.0, 0.0, "흐림", "partly-cloudy-night")
    private let serviceKey: String = "1dce873b7cac9c395f9e708343303309"
    
    // MARK: - Method
    private override init() {}
    public func receiveWeatherData(group: DispatchGroup, language: String) {
        
        guard let location: CLLocation = Location.locationInstance.currentLocation else {
            fatalError("Error, Getting Current Coordinate.")
        }
        
        let weatherURL: String = "https://api.darksky.net/forecast/\(serviceKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)?units=si&lang=\(language)"
        
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async(group: group, execute: { [unowned self] in
            
            Alamofire.request(weatherURL).responseJSON(completionHandler: { (response) in
                
                guard response.result.isSuccess else {
                    group.leave()
                    fatalError("Error, Not Receive Data From Dark SKY Server.")
                }
                
                switch response.response?.statusCode {
                    case .none : print("Error, Not Receive Data From Dark SKY Server.")
                    case .some(_) :
                        guard let result = response.result.value, let json = result as? NSDictionary else { return }
                        guard let list = json["currently"] as? [String:Any] else { return }
                        
                        self.weatherData.temperature    = list["apparentTemperature"] as! Double
                        self.weatherData.humidity       = list["humidity"] as! Double
                        self.weatherData.visibility     = list["visibility"] as! Double
                        self.weatherData.ozone          = list["ozone"] as! Double
                        self.weatherData.sky            = list["summary"] as! String
                        self.weatherData.icon           = list["icon"] as! String
                }
                group.leave()
            })
        })

    }
}
