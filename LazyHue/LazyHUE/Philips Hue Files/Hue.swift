//
//  Hue.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 15..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import Gloss
import SwiftyHue
import AudioToolbox

// MARK: - Protocol
protocol HueAlterDelegate: class {
    func isConnectedBridge()
}

class Hue: NSObject {
    
    // MARK: - typealias
    typealias color = (red: Int, green: Int, blue: Int)
    
    // MARK: - Variable
    fileprivate var hueBridge: HueBridge?
    fileprivate var swiftyHue: SwiftyHue = SwiftyHue()
    fileprivate var hueBridgeFinder: BridgeFinder = BridgeFinder()
    fileprivate var hueAuthenticator: BridgeAuthenticator?
    public static var hueInstance: Hue = Hue()
    public var hueColors: color = (255, 255, 255)
    public var delegate: HueAlterDelegate?
    
    // MARK: - Init
    private override init() {}
    
    // MARK: - Public User Method
    public func connectHueBridge() {
        
        if let bridgeAccessConfig: BridgeAccessConfig = readHueBridgeAccessConfig() {
            swiftyHue.setBridgeAccessConfig(bridgeAccessConfig)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .lights)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .groups)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .rules)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .scenes)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .schedules)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .sensors)
            swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .config)
            swiftyHue.startHeartbeat()
        }
        
        hueBridgeFinder.delegate = self
        hueBridgeFinder.start()
    }
    public func changeHueColor(red: Int, green: Int, blue: Int, alpha: Int) {
        
        guard let lights = swiftyHue.resourceCache?.lights else {
            print("Error, Not Load the philips hue lights.")
            return
        }
        
        // Change Light Color State loop
        for light in lights {
            let colorXY = HueUtilities.calculateXY(UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)), forModel: light.key)
            
            var lightState: LightState = LightState()
            lightState.brightness = alpha
            lightState.xy = [Float(colorXY.x), Float(colorXY.y)]
            
            swiftyHue.bridgeSendAPI.updateLightStateForId(light.key, withLightState: lightState, completionHandler: { error in
                
                guard error == nil else {
                    print("Error, Not Change the philips hue light color. \(String(describing: error))")
                    return
                }
                
                print("- Change fraction philips hue color.")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                showWhisperToast(title: "Change fraction philips hue lamps color.", background: .moss, textColor: .white)
            })
        }
    }
    public func changeHueColor(color: UIColor) {
        
        guard let lights = swiftyHue.resourceCache?.lights else {
            print("Error, Not Load the philips hue lights.")
            return
        }
        
        // Change Light Color State loop
        for light in lights {
            let colorXY = HueUtilities.calculateXY(color, forModel: light.key)
            
            var lightState: LightState = LightState()
            lightState.brightness = 255
            lightState.xy = [Float(colorXY.x), Float(colorXY.y)]
            
            swiftyHue.bridgeSendAPI.updateLightStateForId(light.key, withLightState: lightState, completionHandler: { error in
                
                guard error == nil else {
                    print("Error, Not Change the philips hue light color. \(String(describing: error))")
                    return
                }
                
                print("- Change all philips hue color.")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                showWhisperToast(title: "Change all philips hue lamps color.", background: .moss, textColor: .white)
            })
        }
    }
    public func changeHueColor(red: Int, green: Int, blue: Int, alpha: Int, index: Int) {
        
        guard let lights = swiftyHue.resourceCache?.lights else {
            print("Error, Not Load the philips hue lights.")
            return
        }
        
        let keys: [String] = lights.keys.compactMap({$0})
        if index != 0 && index <= lights.count {
            
            let colorXY = HueUtilities.calculateXY(UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)), forModel: keys[index - 1])
            
            var lightState: LightState = LightState()
            lightState.brightness = alpha
            lightState.xy = [Float(colorXY.x), Float(colorXY.y)]
            
            swiftyHue.bridgeSendAPI.updateLightStateForId(keys[index - 1], withLightState: lightState, completionHandler: { error in
                
                guard error == nil else {
                    print("Error, Not Change the philips hue light color. \(String(describing: error))")
                    return
                }
                
                print("- Change fraction philips hue color.")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                showWhisperToast(title: "Change fraction philips hue lamps color.", background: .moss, textColor: .white)
            })
        }
    }
    public func changeHuePower() {
        
        guard let lights = swiftyHue.resourceCache?.lights else {
            print("Error, Not Load the Philips Hue Lights.")
            return
        }
        
        for light in lights {
            var lightState: LightState = LightState()
            if let state: Bool = light.value.state.on {
                lightState.on = !state
            }
            
            swiftyHue.bridgeSendAPI.updateLightStateForId(light.key, withLightState: lightState,
                completionHandler: { error in
                    
                    guard error == nil else {
                        print("Error, Not Change the Philips hue light Power. \(String(describing: error))")
                        return
                    }
                    
                    print("- Change all philips hue power.")
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    showWhisperToast(title: "Change all philips hue lamps power.", background: .moss, textColor: .white)
            })
        }
    }
    public func changeHuePower(number: Int) {
        
        guard let lights = swiftyHue.resourceCache?.lights else {
            print("Error, Not Load the Philips Hue Lights.")
            return
        }
        
        let keys = lights.keys.compactMap({$0})
        var lightState: LightState = LightState()
        if number <= lights.count && number != 0, let isOn: Bool = lights[keys[number - 1]]?.state.on {
            lightState.on = !isOn
            
            swiftyHue.bridgeSendAPI.updateLightStateForId(keys[number - 1], withLightState: lightState, completionHandler: { error in
                
                guard error == nil else {
                    print("Error, Not Change the Philips hue light Power. \(String(describing: error))")
                    return
                }
                
                print("- Change fraction philips hue power.")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                showWhisperToast(title: "Change fraction philips hue lamps power.", background: .moss, textColor: .white)
            })
        }
    }
    
    // MARK: - Private User Method
    private func readHueBridgeAccessConfig() -> BridgeAccessConfig? {
        let userDefaults: UserDefaults = UserDefaults.standard
        if let bridgeAccessConfigJSON = userDefaults.object(forKey: ACCESS_BRIDGE_KEY) as? JSON {
            return BridgeAccessConfig(json: bridgeAccessConfigJSON)
        }
        
        return nil
    }
    private func writeHueBridgeAccessConfig(bridgeAccessConfig: BridgeAccessConfig) {
        let userDefaults = UserDefaults.standard
        if let bridgeAccessConfigJSON: JSON = bridgeAccessConfig.toJSON() {
            userDefaults.set(bridgeAccessConfigJSON, forKey: ACCESS_BRIDGE_KEY)
            print("- Export philips hue bridge config.")
        }
    }
}

// MARK: - BridgeFinderDelegate Extension
extension Hue: BridgeFinderDelegate {
    
    func bridgeFinder(_ finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
        if let bridge: HueBridge = bridges.first {
            
            hueBridge = bridge
            print("Bridge IP: \(bridge.ip), Bridge NAME: \(bridge.modelName), Bridge Serial: \(bridge.serialNumber)")
            
            // Philips Hue Bridge Authenticator
            hueAuthenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: bridge.serialNumber)
            hueAuthenticator?.delegate = self
            hueAuthenticator?.start()
        }
    }
}

// MAKR: - BridgeAuthenticatorDelegate Extension
extension Hue: BridgeAuthenticatorDelegate {
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFinishAuthentication username: String) {
        
        if let bridge: HueBridge = hueBridge {
            let bridgeConfig = BridgeAccessConfig(bridgeId: bridge.modelName, ipAddress: bridge.ip, username: username)
            swiftyHue.setBridgeAccessConfig(bridgeConfig)
            
            writeHueBridgeAccessConfig(bridgeAccessConfig: bridgeConfig)
            UserDefaults.standard.set(true, forKey: CONNECT_BRIDGE_STATE_KEY)
            print("- Connect philips hue bridge. \(bridgeConfig.ipAddress):\(bridgeConfig.username):\(bridgeConfig.bridgeId)")
            
            // HueAlterDelegate Method
            delegate?.isConnectedBridge()
        }
    }
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
        print("- Philips Hue Bridge Authenticator Error: \(error.localizedDescription)")
    }
    
    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator, secondsLeft: TimeInterval) {}
    
    func bridgeAuthenticatorDidTimeout(_ authenticator: BridgeAuthenticator) {}
}
