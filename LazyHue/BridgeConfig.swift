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
    /* MARK - fileprivate */
    fileprivate let bridgeAccessConfigUserDefaultsKey = "BridgeAccessConfig"
    fileprivate let bridgeLightConfigDefaultsKey = "BridgeResourceConfig"
    fileprivate let userDefaults = UserDefaults.standard
    
    /* MARK - Import Setting Value Method */
    final func readBridgeAccessConfig() -> BridgeAccessConfig?
    {
        let bridgeAccessConfigJSON = userDefaults.object(forKey: bridgeAccessConfigUserDefaultsKey) as? JSON
        
        var bridgeAccessConfig: BridgeAccessConfig?
        if let bridgeAccessConfigJSON = bridgeAccessConfigJSON
        { bridgeAccessConfig = BridgeAccessConfig(json: bridgeAccessConfigJSON) }
        
        return bridgeAccessConfig
    }
    final func readBridgeLightConfig() -> BridgeResourcesCache?
    {
        let bridgeResourceConfigJSON = userDefaults.object(forKey: bridgeLightConfigDefaultsKey) as? JSON
        
        var bridgeResourceConfig:BridgeResourcesCache?
        if let bridgeResouceConfigJSON = bridgeResourceConfigJSON
        { bridgeResourceConfig = BridgeResourcesCache(json: bridgeResouceConfigJSON) }
        
        return bridgeResourceConfig
    }
    
    /* MARK - Export Bridge Setting Value Method */
    final func writeBridgeAccessConfig(bridgeAccessConfig:BridgeAccessConfig)
    {
        let bridgeAccessConfigJSON = bridgeAccessConfig.toJSON()
        userDefaults.set(bridgeAccessConfigJSON, forKey: bridgeAccessConfigUserDefaultsKey)
    }
    final func writeBridgeLightConfig(bridgeResourceConfig:BridgeResourcesCache)
    {
        let bridgeResourceConfigJSON = bridgeResourceConfig.toJSON()
        userDefaults.set(bridgeResourceConfigJSON, forKey: bridgeLightConfigDefaultsKey)
    }
}
