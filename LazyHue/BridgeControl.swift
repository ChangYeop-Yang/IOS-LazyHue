//
//  BirdgeControl.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 8. 7..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import SwiftyHue    /* Philips Hue API */
import Foundation

class BridgeControl
{
    /* Control Light Power Method */
    func ctlLightPower(hue:SwiftyHue, light:String, power:Bool)
    {
        var lightState:LightState = LightState()
        lightState.on = power
        
        hue.bridgeSendAPI.updateLightStateForId(light, withLightState: lightState) { (errors) in print(errors) }
    }
}
