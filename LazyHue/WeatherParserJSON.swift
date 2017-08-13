//
//  ParserJSON.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 8. 12..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import Foundation

enum JSONError: String, Error
{
    case NoData = "ERROR: No Data."
    case ConversionFailed = "ERROR: Conversion from JSON Failed."
}

/* MARK - Struct */
struct weather
{
    /* POINT - INT */
    var nState:Int
    var nHumidity:Int
    var nPrecipitation:Int
    var nSpeed:Int
    
    /* POINT - Float */
    var fTemperature:Float
    
    /* POINT - Init */
    init(nState:Int, nHumidity:Int, nPrecipitation:Int, nSpeed:Int, fTemperature:Float)
    {
        /* POINT - INT */
        self.nState = nState
        self.nHumidity = nHumidity
        self.nPrecipitation = nPrecipitation
        self.nSpeed = nSpeed
        
        /* POINT - FLOAT */
        self.fTemperature = fTemperature
    }
}

class WeatherParserJSON
{
    /* MARK - fileprivate */
    fileprivate let WEATHER_API_KEY:String = "C2d%2FZz%2BaNt0m7s5ShL8GDXiwNqTXE3XETIIaRJDoSxvWxWm929sMakv3t6ZBz28U8cdE0N74NQkIAC1ppwaknw%3D%3D"
    fileprivate var sURL:URL
    
    /* MARK - Init Method */
    init()
    {
        /* POINT - Date */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var sRequestURL:String = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastTimeData?serviceKey="
        sRequestURL.append(WEATHER_API_KEY)
        sRequestURL.append("&base_date=\(dateFormatter.string(from: NSDate() as Date))")
        sRequestURL.append("&base_time=0630&nx=60&ny=127&numOfRows=10&pageSize=10&pageNo=1&startPage=1&_type=xml/")
        
        sURL = URL(string: sRequestURL)!
    }
    
    func resultWeather() -> weather
    {
        var result:weather = weather(nState: 0, nHumidity: 0, nPrecipitation: 0, nSpeed: 0, fTemperature: 0.0)
        
        var urls = URL(string: "http://ip.jsontest.com/")!
        URLSession.shared.dataTask(with: urls, completionHandler: { (data, response, error) in
                do
                {
                    /* POINT - Import Base JSON Parsing */
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let currentCoditions = parsedData["records"] as! [String:Any]
                    
                    /* POINT - Import Result JSON Parsing */
                    result.nState = currentCoditions["SKY"] as! Int
                    result.nHumidity = currentCoditions["REH"] as! Int
                    result.nPrecipitation = currentCoditions["RN1"] as! Int
                    result.nSpeed = currentCoditions["WSD"] as! Int
                    result.fTemperature = currentCoditions["T1H"] as! Float
                    print("Point2")
                }
                catch let error as NSError
                { print("Error, Weather JSON Parsing. \(error)") }
            
        }).resume()
        
        return result
    }
}
