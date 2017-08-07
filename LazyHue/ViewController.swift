//
//  ViewController.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 7. 31..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import UIKit
import SwiftyHue    /* Philips Hue API */

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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        swiftyHue.enableLogging(true)
        swiftyHue.setMinLevelForLogMessages(.info)
        
        /* Bridge Config Check */
        if let config:BridgeAccessConfig = bridgeConfig.readBridgeAccessConfig()
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
        }
        else { bridgeFinder.delegate = self; bridgeFinder.start(); }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        bridgeConfig.writeBridgeAccessConfig(bridgeAccessConfig: bridgeAccessConfig)
    }
    
    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator, secondsLeft: TimeInterval) {
        print("Please, Push top bridge button.")
    }
    
    /* MARK : - IBAction Method */
    @IBAction func actPowerSwitch(_ sender: UISwitch)
    {
        for item in (swiftyHue.resourceCache?.lights)!
        { bridgeControl.ctlLightPower(light: item.key, power: sender.isOn) }
    }
    
    @IBAction func actColorSlider(_ sender: UISlider)
    {
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
            default : nHue = Int(sliderHue.value); break;
        }
        
        for item in (swiftyHue.resourceCache?.lights)!
        { bridgeControl.ctlLightColor(light: item.key, red: nRed, blue: nBlue, green: nGreen, hue: nHue) }
    }
}
