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
    @IBOutlet weak var weatherStateIMG: UIImageView! {
        didSet {
            weatherStateIMG.clipsToBounds = true;
            weatherStateIMG.layer.masksToBounds = true
            weatherStateIMG.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var humidityLB: UILabel!
    @IBOutlet weak var precipitationLB: UILabel!
    @IBOutlet weak var temperatureLB: UILabel!
    @IBOutlet weak var dustLB: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var remoteIMG: UIImageView!
    @IBOutlet weak var updateDateLB: UILabel!
    @IBOutlet weak var innerHumidityLB: UILabel!
    @IBOutlet weak var innerTemputerLB: UILabel!
    @IBOutlet weak var innertNoiseCo2LB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // MARK: Weather Information
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [unowned self] _ in
            self.getCurrentWeather(temperatureLB: self.temperatureLB, humidityLB: self.humidityLB, precipitationLB: self.precipitationLB, stateIMG: self.weatherStateIMG)
        })
        
        // MARK: Weather Dust Information
        getTodayFineDust(label: dustLB)
        
        // MARK: UIImageView Gesture
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(gestureChangePower(longGestureRecognizer:)))
        remoteIMG.isUserInteractionEnabled = true
        remoteIMG.addGestureRecognizer(gesture)
        
        // MARK: Arduino Information
        if UserDefaults.standard.bool(forKey: ARUDINO_ENABLE_KEY) {
            getArduinoSensory(dateLabel: updateDateLB, tempLabel: innerTemputerLB, humidity: innerHumidityLB, co2AndNoise: innertNoiseCo2LB)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: Spinner
        if Weather.weatherInstance.weatherData.sky == "정보없음" { SwiftSpinner.show("Just a minute.", animated: true) }
        
        // MARK: Check Connecting Philips hue bridge.
        if !Hue.hueInstance.connectHueBridge(), let pressView = UINib(nibName: "PressHueBridge", bundle: nil).instantiate(withOwner: self, options: nil).first as? PressHueBridge {
            pressView.center = self.view.center
            self.view.addSubview(pressView)
        }
        
        // MARK: Load Philips hue Colors.
        Hue.hueInstance.hueColors = Hue.color(UserDefaults.standard.integer(forKey: HUE_COLOR_RED_KEY), UserDefaults.standard.integer(forKey: HUE_COLOR_GREEN_KEY), UserDefaults.standard.integer(forKey: HUE_COLOR_BLUE_KEY))
        
        // MARK: UISlider
        redSlider.value = Float(Hue.hueInstance.hueColors.red)
        greenSlider.value = Float(Hue.hueInstance.hueColors.green)
        blueSlider.value = Float(Hue.hueInstance.hueColors.blue)
    }

    // MARK: - Method
    private func getArduinoSensory(dateLabel: UILabel, tempLabel: UILabel, humidity: UILabel, co2AndNoise: UILabel) {
        
        let arduinoGroup: DispatchGroup = DispatchGroup()
        Sensory.sensoryInstance.parsorSensorDataJSON(url: "http://106.10.52.101/Arduino/selectArduino.php", group: arduinoGroup)
        
        arduinoGroup.notify(queue: .main, execute: {
            dateLabel.text      = "측정 날짜 - \(String(describing: Sensory.sensoryInstance.dateList.first!))"
            tempLabel.text      = "실내 온도 - \(String(describing: Sensory.sensoryInstance.temputuerList.first!.rounded()))℃"
            humidity.text       = "실내 습도 - \(String(describing: Sensory.sensoryInstance.humidityList.first!.rounded()))%"
            co2AndNoise.text    = "\(Sensory.sensoryInstance.gasList.first!.rounded())% | \(Sensory.sensoryInstance.noiseList.first!.rounded())dB | \(Sensory.sensoryInstance.cdsList.first!.rounded())Lx"
        })
    }
    private func getTodayFineDust(label: UILabel) {
        
        let dustGroup: DispatchGroup = DispatchGroup()
        Dust.dustInstance.receiveDustData(adminArea: "경상북도", group: dustGroup)
        
        dustGroup.notify(queue: .main, execute: {
            if let findDustValue: Int = Int(Dust.dustInstance.result) {
                label.text = "오늘의 미세먼지 : \(findDustValue)㎍/㎥"
                
                switch findDustValue {
                    case 0..<50: label.textColor = UIColor.black
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
            showWhisperToast(title: "Success search current address", background: .moss, textColor: .white)
            label.text = Location.locationInstance.currentAddress
        })
    }
    private func getCurrentWeather(temperatureLB: UILabel, humidityLB: UILabel, precipitationLB: UILabel, stateIMG: UIImageView) {
        
        let weatherGroup: DispatchGroup = DispatchGroup()
        Weather.weatherInstance.receiveWeatherData(group: weatherGroup, language: "ko")
        
        weatherGroup.notify(queue: .main, execute: {
            temperatureLB.text      = "오늘의 날씨 - \(Weather.weatherInstance.weatherData.sky)"
            humidityLB.text         = "\(Weather.weatherInstance.weatherData.temperature) ℃ | \(Weather.weatherInstance.weatherData.humidity * 100) %"
            precipitationLB.text    = "\(Weather.weatherInstance.weatherData.ozone) PPM | \(Weather.weatherInstance.weatherData.visibility) KM"
            stateIMG.image = UIImage(named: Weather.weatherInstance.weatherData.icon)
            
            // MARK: Spinner
            if SwiftSpinner.sharedInstance.animating { SwiftSpinner.hide() }
        })
    }
    @objc private func gestureChangePower(longGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longGestureRecognizer.state == .ended {
            Hue.hueInstance.changeHuePower()
        }
    }
    
    // MARK: - IBAction Method
    @IBAction func changeColorsValue(_ sender: UISlider) {
        
        AudioServicesPlaySystemSound(4095)
        print("- Change all philips hue colors.")
        showWhisperToast(title: "Change all philips hue lamps colors.", background: UIColor(red: CGFloat(redSlider.value) / 255, green: CGFloat(greenSlider.value) / 255, blue: CGFloat(blueSlider.value) / 255, alpha: 100), textColor: .black)
        
        Hue.hueInstance.hueColors = Hue.color(Int(redSlider.value), Int(greenSlider.value), Int(blueSlider.value))
        print(Hue.hueInstance.hueColors)
        Hue.hueInstance.changeHueColor(red: Int(redSlider.value), green: Int(greenSlider.value), blue: Int(blueSlider.value), alpha: 255)
        
    }
    @IBAction func loadCurrentLocation(_ sender: UIButton) {
        AudioServicesPlaySystemSound(4095)
        getCurrentAddress(label: locationLB)
        getCurrentWeather(temperatureLB: temperatureLB, humidityLB: humidityLB, precipitationLB: precipitationLB, stateIMG: weatherStateIMG)
    }

    // MARK: - Motion Event Method
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if UserDefaults.standard.bool(forKey: MOTION_ENABLE_KEY) {
            Hue.hueInstance.changeHuePower()
        }
    }
}

