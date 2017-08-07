//
//  BridgeConfig.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 8. 5..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import Gloss        /* Json API */
import SwiftyHue    /* Philips Hue API */
import Foundation

class BridgeConfig
{
    fileprivate let bridgeAccessConfigUserDefaultsKey = "BridgeAccessConfig"
    
    /* Import Bridge Setting Value */
    func readBridgeAccessConfig() -> BridgeAccessConfig?
    {
        let userDefaults = UserDefaults.standard
        let bridgeAccessConfigJSON = userDefaults.object(forKey: bridgeAccessConfigUserDefaultsKey) as? JSON
        
        var bridgeAccessConfig: BridgeAccessConfig?
        if let bridgeAccessConfigJSON = bridgeAccessConfigJSON
        { bridgeAccessConfig = BridgeAccessConfig(json: bridgeAccessConfigJSON) }
        
        return bridgeAccessConfig
    }
    
    /* Export Bridge Setting Value */
    func writeBridgeAccessConfig(bridgeAccessConfig:BridgeAccessConfig)
    {
        let userDefaults = UserDefaults.standard
        let bridgeAccessConfigJSON = bridgeAccessConfig.toJSON()
        userDefaults.set(bridgeAccessConfigJSON, forKey: bridgeAccessConfigUserDefaultsKey)
    }
}
