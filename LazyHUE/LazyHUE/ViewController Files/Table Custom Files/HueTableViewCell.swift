//
//  HueTableViewCell.swift
//  LazyHUE
//
//  Created by 양창엽 on 09/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit
import AudioToolbox

class HueTableViewCell: UITableViewCell {
    
    // MARK: - Enum
    private enum SliderTag: Int {
        case Red    = 100
        case Green  = 200
        case Blue   = 300
        case Alpha  = 400
    }
    
    // MARK: - Outlet Variables
    @IBOutlet private weak var nameHueLB: UILabel!
    @IBOutlet private weak var numberHueLB: UILabel!
    @IBOutlet private weak var colorHueLB: RoundView!
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    @IBOutlet private weak var alphaSlider: UISlider!

    // MARK: - Variables
    private var index: Int = 0
    private var color: Hue.HueColor = (0, 0, 0, 0)
    
    // MARK: - Internal User Method
    internal func setIndexPath(index: Int) {
        self.index = index
    }
    internal func initHueCell() {
        
        let lightState: Hue.HueLightState = getHueLightState()
        
        //self.color = Hue.hueInstance.convertXYToColor(key: getHueKey(), state: lightState.state)
        //print(lightState.type)
        let mm = UIColor(hue: CGFloat(lightState.state.hue!), saturation: CGFloat(lightState.state.saturation!), brightness: CGFloat(lightState.state.brightness!), alpha: CGFloat(254))
        print("ASD - \(mm.rgba)")
        DispatchQueue.main.async { [unowned self] in
            self.nameHueLB.text     = lightState.name
            self.numberHueLB.text   = "#\(self.index + 1)"
        }
    }
    
    // MARK: - Private User Method
    private func getHueKey() -> String {
        let keys: [String] = Hue.hueInstance.getHueLights().keys.compactMap( {$0} )
        return keys[self.index]
    }
    private func getHueLightState() -> Hue.HueLightState {
        let lightState: [Hue.HueLightState] = Hue.hueInstance.getHueLights().values.compactMap( {$0} )
        return lightState[self.index]
    }

    // MARK: - Action Method
    @IBAction private func changeSliderValue(_ sender: UISlider) {
        
        guard let tag: SliderTag = SliderTag(rawValue: sender.tag) else {
            return
        }
        
        switch tag {
            case .Red:      color.red   = Int(sender.value)
            case .Green:    color.green = Int(sender.value)
            case .Blue:     color.blue  = Int(sender.value)
            case .Alpha:    color.alpha = Int(sender.value)
        }
        
        Hue.hueInstance.changeHueColor(color: color, brightness: color.alpha, key: getHueKey())
    }
}
