//
//  TableViewCell.swift
//  LazyHUE
//
//  Created by 양창엽 on 03/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit
import AudioToolbox

class TableViewCell: UITableViewCell {
    
    // MARK: - Type
    private typealias Color = (red: Int, green: Int, blue: Int, lux: Int)
    
    // MARK: - Enum
    private enum SegmentIndex: Int {
        case HighBright = 0
        case MiddleBright = 1
        case LowbrightBright = 2
    }
    private enum SliderTag: Int {
        case Red = 100
        case Green = 200
        case Blue = 300
    }
    
    // MARK: - Outlet Variables
    @IBOutlet private weak var bulbNameLB: UILabel!
    @IBOutlet private weak var bulbNumberLB: UILabel!
    @IBOutlet private weak var bulbPowerBT: UIButton!
    
    // MARK: - Variables
    private var index: Int = 0
    private var colorINF: Color = (0, 0, 0, 0)
    
    // MAKR: - User Method
    internal func setColorINF(red: Int, green: Int, blue: Int, lux: Int) {
        self.colorINF = (red, green, blue, lux)
    }
    internal func setTableCellIndex(index: Int) {
        self.index = index
    }
    internal func setBulbINF(name: String, index: Int) {
        self.bulbNameLB.text = name
        self.bulbNumberLB.text = "#\(index + 1)"
    }

    // MARK: - Action Method
    @IBAction func changePower(_ sender: UIButton) {
        Hue.hueInstance.changeHuePower(number: self.index)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        sender.titleLabel?.text = (sender.titleLabel?.text == "F" ? "T" : "F")
    }
    @IBAction func changeSliderColor(_ sender: UISlider) {
        
        guard let tag: SliderTag = SliderTag(rawValue: sender.tag) else {
            return
        }

        switch tag {
            case .Red:      self.colorINF.red   = Int(sender.value)
            case .Green:    self.colorINF.green = Int(sender.value)
            case .Blue:     self.colorINF.blue  = Int(sender.value)
        }
        
        Hue.hueInstance.changeHueColor(red: colorINF.red, green: colorINF.green, blue: colorINF.blue, alpha: colorINF.lux, index: index)
    }
    @IBAction func changeLux(_ sender: UISegmentedControl) {
        
        guard let index: SegmentIndex = SegmentIndex(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        switch index {
            case .HighBright:       self.colorINF.lux = 255
            case .MiddleBright:     self.colorINF.lux = 125
            case .LowbrightBright:  self.colorINF.lux = 65
        }
        
        Hue.hueInstance.changeHueColor(red: self.colorINF.red, green: self.colorINF.green, blue: self.colorINF.blue, alpha: self.colorINF.lux, index: self.index)
    }
}
