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

struct Color:Glossy
{
    let Red:Float?
    let Green:Float?
    let Blue:Float?
    let Hue:Float?
    
    init?(json: JSON)
    {
        self.Red = "Red" <~~ json
        self.Green = "Green" <~~ json
        self.Blue = "Blue" <~~ json
        self.Hue = "Hue" <~~ json
    }
    
    func toJSON() -> JSON?
    { return jsonify(["Red" ~~> self.Red, "Green" ~~> self.Green, "Blue" ~~> self.Blue, "Hue" ~~> self.Hue]) }
}

class BridgeConfig
{
    fileprivate let userDefaults = UserDefaults.standard
    
    /* MARK - Import Setting Value Method */
    final func readJSONConfig(type:Int) -> Any
    {
        /* POINT : - Return Value */
        var result:Any? = nil
        
        switch type
        {
            case ConfigData.CONFIG_ACCESS_CODE:
                let configAccessJSON = userDefaults.object(forKey: ConfigData.BRIDGE_ACCESS_CONFIG_KEY) as? JSON
                
                guard let configAccess = configAccessJSON else { print("Error, Empty Access JSON File."); break }
                result = BridgeAccessConfig(json: configAccess)
            
            case ConfigData.CONFIG_LIGHT_CODE:
                let configLightJSON = userDefaults.object(forKey: ConfigData.BRIDGE_LIGHT_CONFIG_KEY) as? JSON
                
                guard let configLight = configLightJSON else { print("Error, Empty Light JSON File."); break }
                let jColor = Color(json: configLight)
                result = ["Red":jColor?.Red, "Green":jColor?.Green, "Blue":jColor?.Blue, "Hue":jColor?.Hue]
            
            default : print("Error, Read JSON File.")
        }
        
        return result as Any
    }
    
    /* MARK - Export Bridge Setting Value Method */
    final func writeJSONConfig(config:Any, type:Int)
    {
        switch type
        {
            case ConfigData.CONFIG_ACCESS_CODE :
                let accessConfigJSON = (config as! BridgeAccessConfig).toJSON()
                userDefaults.set(accessConfigJSON, forKey: ConfigData.BRIDGE_ACCESS_CONFIG_KEY)
            
            case ConfigData.CONFIG_LIGHT_CODE :
                let sColor = Color(json: config as! JSON)
                userDefaults.set(sColor?.toJSON(), forKey: ConfigData.BRIDGE_LIGHT_CONFIG_KEY)
            
            default : print("Error, Write JSON File.")
        }
    }
}
