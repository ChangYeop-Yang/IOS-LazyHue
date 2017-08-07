//
//  BirdgeControl.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 8. 7..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import UIKit
import SwiftyHue    /* Philips Hue API */
import Foundation

class BridgeControl
{
    /* MARK - fileprive */
    fileprivate var swiftyHue:SwiftyHue
    
    init(swiftyHue:SwiftyHue)
    { self.swiftyHue = swiftyHue }
    
    /* MARK - Control Light Power Method */
    final func ctlLightPower(light:String, power:Bool)
    {
        var lightState:LightState = LightState()
        lightState.on = power
        
        swiftyHue.bridgeSendAPI.updateLightStateForId(light, withLightState: lightState) { (errors) in print(errors) }
    }
    
    /* MARK - Control Light Color Method */
    final func ctlLightColor(light:String, red:Int, blue:Int, green:Int, hue:Int)
    {
        let colorXY = HueUtilities.calculateXY(UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(1)), forModel: light)
        
        var lightState:LightState = LightState()
        lightState.brightness = hue
        lightState.xy = [Float(colorXY.x), Float(colorXY.y)]
        swiftyHue.bridgeSendAPI.updateLightStateForId(light, withLightState: lightState) { (errors) in print(errors) }
    }
}
