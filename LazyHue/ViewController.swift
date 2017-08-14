//
//  ViewController.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 7. 31..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import UIKit
import Alamofire    /* Alamofire API */
import SwiftyHue    /* Philips Hue API */
import SwiftyJSON   /* Swifty JSON API */

/* MARK : - Public Variable */
var swiftyHue:SwiftyHue = SwiftyHue()

class ViewController: UIViewController, BridgeFinderDelegate, BridgeAuthenticatorDelegate
{
    /* MARK : - fileprivate */
    fileprivate var bridge:HueBridge!
    fileprivate let bridgeConfig:BridgeConfig = BridgeConfig()
    fileprivate let bridgeControl:BridgeControl = BridgeControl(swiftyHue: swiftyHue)
    fileprivate let bridgeFinder:BridgeFinder = BridgeFinder()
    fileprivate var bridgeAuthenticator:BridgeAuthenticator?
    
    /* MARK : - Slider Outlet */
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderHue: UISlider!
    
    /* MARK : - Label Outlet */
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelPrecipitation: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    
    /* MARK : - Image Outlet */
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var imagePaint: UIImageView!
    
    override func loadView()
    {
        super.loadView()
        
        swiftyHue.enableLogging(true)
        swiftyHue.setMinLevelForLogMessages(.info)
        
        /* Bridge Config Check */
        if let config = bridgeConfig.readJSONConfig(type: ConfigData.CONFIG_ACCESS_CODE) as? BridgeAccessConfig
        {
            swiftyHue.setBridgeAccessConfig(config)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .lights)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .groups)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .rules)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .scenes)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .schedules)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .sensors)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .config)
            swiftyHue.startHeartbeat()
        } else { bridgeFinder.delegate = self; bridgeFinder.start(); }
        
        /* POINT : - Press Home Button */
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(pressHomeKey), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* POINT : - Import Bridge Resource */
        if let result = bridgeConfig.readJSONConfig(type: ConfigData.CONFIG_LIGHT_CODE) as? [String:Float]
        {
            sliderRed.value = result["Red"]!; sliderGreen.value = result["Green"]!
            sliderBlue.value = result["Blue"]!; sliderHue.value = result["Hue"]!
            
            guard let cache = swiftyHue.resourceCache?.lights else { print("Error, Empty Light List."); return }
            for item in cache
            {
                bridgeControl.ctlLightColor(light: item.key, red: Int(result["Red"]!), blue: Int(result["Blue"]!), green: Int(result["Green"]!), hue: Int(result["Hue"]!))
            }
        }
        
        /* POINT : - Import KMA Server. */
        let sRequestURL:String = createRequestAddress(latitude: 0.0, longitude: 0.0)
        importKMAWeatherData(sURL: sRequestURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* MARK : - Press Home Button Method */
    func pressHomeKey()
    {
        let aSliderValue = ["Red":sliderRed.value, "Green":sliderGreen.value, "Blue":sliderBlue.value, "Hue":sliderHue.value]
        bridgeConfig.writeJSONConfig(config: aSliderValue, type: ConfigData.CONFIG_LIGHT_CODE)
    }
    
    /* MARK : - User Custom Method */
    func createRequestAddress(latitude:Double, longitude:Double) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var sRequestURL:String = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastTimeData?serviceKey="
        sRequestURL.append(WeatherData.KMA_API_KEY)
        sRequestURL.append("&base_date=\(dateFormatter.string(from: NSDate() as Date))"); dateFormatter.dateFormat = "HHmm"
        sRequestURL.append("&base_time=\(dateFormatter.string(from: NSDate() as Date))")
        sRequestURL.append("&nx=60&ny=127&numOfRows=30&pageSize=10&pageNo=1&startPage=1&_type=json")
        
        return sRequestURL
    }
    
    func setWeatherState(type:Int)
    {
        switch type
        {
            case WeatherData.SKY_CLEAR:
                self.labelState.text = "⌘ 상태 : 맑음"
                self.imageWeather.image = #imageLiteral(resourceName: "ic_clear.png")
            case WeatherData.SKY_PARTLY_CLOUDY:
                self.labelState.text = "⌘ 상태 : 구름조금"
                self.imageWeather.image = #imageLiteral(resourceName: "ic_cloudy.png")
            case WeatherData.SKY_OVER_CLOUDY:
                self.labelState.text = "⌘ 상태 : 구름많음"
                self.imageWeather.image = #imageLiteral(resourceName: "ic_over.png")
            case WeatherData.SKY_BLOOMING:
                self.labelState.text = "⌘ 상태 : 흐림"
                self.imageWeather.image = #imageLiteral(resourceName: "ic_blooming.png")
            default:
                self.labelState.text = "⌘ 상태 : 정보없음"
        }
    }
    
    func importKMAWeatherData(sURL:String)
    {
        let jsonHeder:[String] = ["response", "body", "items", "item"]
        
        Alamofire.request(sURL).responseJSON(queue: DispatchQueue.global(qos: .utility))
        {
            (response) in
            switch response.result
            {
                case .success:
                    guard let value = response.result.value
                        else { print("Error, Download Remote Server JSON File."); break; }
                
                    /* POINT - Find JSON Header Position. */
                    var swiftyJSON = JSON(value)
                    for item in jsonHeder { swiftyJSON = swiftyJSON[item] }
                
                    /* POINT - FIND JSON Value. */
                    for item in swiftyJSON
                    {
                        switch item.1["category"]
                        {
                            case "T1H" : self.labelTemperature.text = "⌘ 기온 : \(item.1["fcstValue"].stringValue) &deg"
                            case "RN1" : self.labelPrecipitation.text = "⌘ 강수량 : \(item.1["fcstValue"].intValue) mm"
                            case "SKY" : self.setWeatherState(type: item.1["fcstValue"].intValue)
                            case "REH" : self.labelHumidity.text = "⌘ 습도 : \(item.1["fcstValue"].intValue) %"
                            case "WSD" : self.labelSpeed.text = "⌘ 풍속 : \(item.1["fcstValue"].intValue) m/s"
                            default : continue
                        }
                    }
                case .failure(let error) : print("Error, Connect Remote Server.")
            }
        }
    }
    
    /* MARK : - BridgeFinderDelegate */
    func bridgeFinder(_ finder: BridgeFinder, didFinishWithResult bridges: [HueBridge])
    {
        print(bridges)
        
        bridge = bridges.first!
        
        bridgeAuthenticator = BridgeAuthenticator(bridge: bridge!, uniqueIdentifier: "example#simulator")
        bridgeAuthenticator!.delegate = self
        bridgeAuthenticator!.start()
    }
    
    /* MARK : - BridgeAuthenticatorDelegate */
    func bridgeAuthenticatorDidTimeout(_ authenticator: BridgeAuthenticator) {
        print("Timeout")
    }
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
        print("Error while authenticating: \(error)")
    }
    
    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator) {
        print("Press link button")
    }
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFinishAuthentication username: String)
    {
        print("Authenticated, hello \(username)")
        
        let bridgeAccessConfig = BridgeAccessConfig(bridgeId: bridge.serialNumber, ipAddress: bridge.ip, username: username)
        
        bridgeConfig.writeJSONConfig(config: bridgeAccessConfig, type: ConfigData.CONFIG_ACCESS_CODE)
    }
    
    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator, secondsLeft: TimeInterval) {
        print("Please, Push top bridge button.")
    }
    
    /* MARK : - IBAction Method */
    @IBAction func actPowerSwitch(_ sender: UISwitch)
    {
        guard let bridgeCache = swiftyHue.resourceCache?.lights else { print("Error, Empty Light List."); return }
        
        for item in bridgeCache
        { bridgeControl.ctlLightPower(light: item.key, power: sender.isOn) }
    }
    
    @IBAction func actColorSlider(_ sender: UISlider)
    {
        guard let bridgeCache = swiftyHue.resourceCache?.lights else { return }
        
        /* Color Variable */
        var nRed:Int = Int(sliderRed.value)
        var nBlue:Int = Int(sliderBlue.value)
        var nGreen:Int = Int(sliderGreen.value)
        var nHue:Int = Int(sliderHue.value)
        
        switch (sender.tag)
        {
            /* Red Slider */
            case 15 : nRed = Int(sender.value); break;
            /* Green Slider */
            case 16 : nGreen = Int(sender.value); break;
            /* Blue Slier */
            case 17 : nBlue = Int(sender.value); break;
            /* Hue Slider */
            default : nHue = Int(sender.value); break;
        }
        
        for item in bridgeCache
        { bridgeControl.ctlLightColor(light: item.key, red: nRed, blue: nBlue, green: nGreen, hue: nHue) }
    }
}
