//
//  ViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 6. 20..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import SwiftSpinner
import AudioToolbox

class HomeViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var weatherStateIMG: UIImageView! {
        didSet {
            weatherStateIMG.clipsToBounds = true;
            weatherStateIMG.layer.masksToBounds = true
            weatherStateIMG.layer.cornerRadius = 10
        }
    }
    @IBOutlet private weak var locationLB: UILabel!
    @IBOutlet private weak var humidityLB: UILabel!
    @IBOutlet private weak var precipitationLB: UILabel!
    @IBOutlet private weak var temperatureLB: UILabel!
    @IBOutlet private weak var dustLB: UILabel!
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    @IBOutlet private weak var remoteIMG: UIImageView!
    @IBOutlet private weak var updateDateLB: UILabel!
    @IBOutlet private weak var innerHumidityLB: UILabel!
    @IBOutlet private weak var innerTemputerLB: UILabel!
    @IBOutlet private weak var innertNoiseCo2LB: UILabel!
    @IBOutlet private weak var outsideArduinoCV: CardView!
    
    // MARK: - Variables
    private var currentColor: Hue.HueColor = (125, 125, 125, 255)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Weather Information
        SwiftSpinner.show("Just a minute.", animated: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [unowned self] _ in
            self.getCurrentWeather(temperatureLB: self.temperatureLB, humidityLB: self.humidityLB, precipitationLB: self.precipitationLB, stateIMG: self.weatherStateIMG)
        })
        
        // MARK: Weather Dust Information
        getTodayFineDust(label: dustLB)
        
        // MARK: UIImageView Gesture
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.setDoubleTapGesture(gestureRecognizer:)))
        gesture.numberOfTapsRequired = 2
        self.remoteIMG.isUserInteractionEnabled = true
        self.remoteIMG.addGestureRecognizer(gesture)
        
        // MARK: Arduino Information
        if UserDefaults.standard.bool(forKey: ARUDINO_ENABLE_KEY) {
            outsideArduinoCV.isHidden = true
            getArduinoSensory(dateLabel: updateDateLB, tempLabel: innerTemputerLB, humidity: innerHumidityLB, co2AndNoise: innertNoiseCo2LB)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Core Data
        if let color: HueColor = HueData.hueDataInstance.fetchHueColor(entityName: HUE_OBJECT_COLOR_ENTITY_NAME) {
            self.redSlider.value    = color.redColor
            self.greenSlider.value  = color.greenColor
            self.blueSlider.value   = color.blueColor
        } else { HueData.hueDataInstance.createHueColorData(red: 125, green: 125, blue: 125, alpha: 255) }
    }

    // MARK: - Private User Method
    private func getArduinoSensory(dateLabel: UILabel, tempLabel: UILabel, humidity: UILabel, co2AndNoise: UILabel) {
        
        let arduinoGroup: DispatchGroup = DispatchGroup()
        Sensory.sensoryInstance.parsorSensorDataJSON(url: "http://106.10.52.101/Arduino/selectArduino.php", group: arduinoGroup)
        
        arduinoGroup.notify(queue: .main, execute: {
            dateLabel.text      = "📅 측정 날짜 - \(String(describing: Sensory.sensoryInstance.dateList.last!))"
            tempLabel.text      = "🌡️ 실내 온도 - \(String(describing: Sensory.sensoryInstance.temputuerList.last!.rounded()))℃"
            humidity.text       = "💦 실내 습도 - \(String(describing: Sensory.sensoryInstance.humidityList.last!.rounded()))%"
            co2AndNoise.text    = "\(Sensory.sensoryInstance.gasList.last!.rounded())% | \(Sensory.sensoryInstance.noiseList.last!.rounded())dB | \(Sensory.sensoryInstance.cdsList.last!.rounded())Lx"
        })
    }
    private func getTodayFineDust(label: UILabel) {
        
        let dustGroup: DispatchGroup = DispatchGroup()
        Dust.dustInstance.receiveDustData(adminArea: "경상북도", group: dustGroup)
        
        dustGroup.notify(queue: .main, execute: {
            if let findDustValue: Int = Int(Dust.dustInstance.result) {
                
                label.text = "오늘의 미세먼지 - \(findDustValue)㎍/㎥"
                
                switch findDustValue {
                    case 0..<50: label.text?.append(" 😀")
                    case 50..<100: label.text?.append(" 😐")
                    case 100..<150: label.text?.append(" 😫")
                    default: label.text?.append(" 🤢")
                }
            }
        })
    }
    private func getCurrentAddress(label: UILabel) {
        let group: DispatchGroup = DispatchGroup()
        Location.locationInstance.getCurrentAddress(group: group)
        
        group.notify(queue: .main, execute: {
            showWhisperToast(title: "Success search current address", background: .moss, textColor: .white)
            label.text = Location.locationInstance.currentAddress
        })
    }
    private func getCurrentWeather(temperatureLB: UILabel, humidityLB: UILabel, precipitationLB: UILabel, stateIMG: UIImageView) {
        
        let weatherGroup: DispatchGroup = DispatchGroup()
        Weather.weatherInstance.receiveWeatherData(group: weatherGroup, language: "ko")
        
        weatherGroup.notify(queue: .main, execute: {
            SwiftSpinner.hide()
            
            // Set Text label here.
            temperatureLB.text      = "⛱️ 오늘의 날씨 - \(Weather.weatherInstance.weatherData.sky)"
            humidityLB.text         = "🌡️ \(Weather.weatherInstance.weatherData.temperature) ℃ 💦 \(Weather.weatherInstance.weatherData.humidity.rounded() * 100) %"
            precipitationLB.text    = "☀️ \(Weather.weatherInstance.weatherData.ozone.rounded()) PPM 🌈 \(Weather.weatherInstance.weatherData.visibility.rounded()) KM"
            stateIMG.image = UIImage(named: Weather.weatherInstance.weatherData.icon)
        })
    }
    @objc private func setDoubleTapGesture(gestureRecognizer: UITapGestureRecognizer) {

        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        Hue.hueInstance.changeHueColor(red: self.currentColor.red, green: self.currentColor.green, blue: self.currentColor.blue, alpha: self.currentColor.alpha)
    }
    
    // MARK: - IBAction Method
    @IBAction private func changeColorsValue(_ sender: UISlider) {
        
        currentColor = (Int(self.redSlider.value), Int(self.greenSlider.value), Int(self.blueSlider.value), 255)
        
        showWhisperToast(title: "Change all philips hue lamps colors.", background: UIColor(red: self.currentColor.red, green: self.currentColor.green, blue: self.currentColor.blue), textColor: .black)
        
        Hue.hueInstance.changeHueColor(red: self.currentColor.red, green: self.currentColor.green, blue: self.currentColor.blue, alpha: self.currentColor.alpha)
        
        // Update Philips Hue Color Core Data here.
        HueData.hueDataInstance.updateHueColor(entityName: HUE_OBJECT_COLOR_ENTITY_NAME, red: self.redSlider.value, green: self.greenSlider.value, blue: self.blueSlider.value, alpha: 255)
    }
    @IBAction private func loadCurrentLocation(_ sender: UIButton) {
        AudioServicesPlaySystemSound(4095)
        getCurrentAddress(label: locationLB)
        getCurrentWeather(temperatureLB: temperatureLB, humidityLB: humidityLB, precipitationLB: precipitationLB, stateIMG: weatherStateIMG)
    }

    // MARK: - Motion Event Method
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        switch motion {
            case .motionShake:
                if UserDefaults.standard.bool(forKey: MOTION_ENABLE_KEY) {
                    Hue.hueInstance.changeHuePower()
                }
            default: break;
        }
    }
}

