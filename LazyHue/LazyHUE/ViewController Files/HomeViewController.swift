//
//  ViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 6. 20..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import Whisper
import AudioToolbox

class HomeViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var weatherSVG: UIView!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var humidityLB: UILabel!
    @IBOutlet weak var precipitationLB: UILabel!
    @IBOutlet weak var temperatureLB: UILabel!
    @IBOutlet weak var dustLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // MARK: Weather Dust Information
        getTodayFineDust(label: dustLB)
        
        // MARK: Weather Information
        Location.locationInstance.startLocation()
        Location.locationInstance.locationGruop.notify(queue: .main, execute: { [unowned self] in
            self.getCurrentWeather(temperatureLB: self.temperatureLB, humidityLB: self.humidityLB, precipitationLB: self.precipitationLB)
        })
    }

    // MARK: - Method
    private func getTodayFineDust(label: UILabel) {
        
        let dustGroup: DispatchGroup = DispatchGroup()
        Dust.dustInstance.receiveDustData(adminArea: "경상북도", group: dustGroup)
        
        dustGroup.notify(queue: .main, execute: {
            if let findDustValue: Int = Int(Dust.dustInstance.result) {
                label.text = "오늘의 미세먼지 : \(findDustValue)㎍/㎥"
                
                switch findDustValue {
                    case 0..<50: label.textColor = UIColor.green
                    case 50..<100: label.textColor = UIColor.yellow
                    case 100..<150: label.textColor = UIColor.red
                    default: label.textColor = UIColor.purple
                }
            }
        })
    }
    private func getCurrentAddress(label: UILabel) {
        let group: DispatchGroup = DispatchGroup()
        Location.locationInstance.getCurrentAddress(group: group)
        
        group.notify(queue: .main, execute: {
            showWhisperToast(title: "Success Search Current Address", background: .moss, textColor: .white)
            label.text = Location.locationInstance.currentAddress
        })
    }
    private func getCurrentWeather(temperatureLB: UILabel, humidityLB: UILabel, precipitationLB: UILabel) {
        
        let weatherGroup: DispatchGroup = DispatchGroup()
        Weather.weatherInstance.receiveWeatherData(group: weatherGroup)
        temperatureLB.text      = "오늘의 온도 : \(Weather.weatherInstance.weatherData.temperature)℃"
        humidityLB.text         = "오늘의 습도 : \(Weather.weatherInstance.weatherData.humidity)%"
        precipitationLB.text    = "오늘의 강수확률 : \(Weather.weatherInstance.weatherData.rain)%"
    }
    
    // MARK: - IBAction Method
    @IBAction func loadCurrentLocation(_ sender: UIButton) {
        AudioServicesPlaySystemSound(4095)
        getCurrentAddress(label: locationLB)
    }
}

