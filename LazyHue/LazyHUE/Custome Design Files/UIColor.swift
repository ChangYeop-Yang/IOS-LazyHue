//
//  UIColor.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 11..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // MARK: - Variables
    internal var hexString: String {
        let components = self.cgColor.components
        
        let red = Float((components?[0])!)
        let green = Float((components?[1])!)
        let blue = Float((components?[2])!)
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
    internal var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    // MARK: - Static Variables
    internal static let blanchedalmond: UIColor = UIColor(red: 255/255, green: 235/255, blue: 205/255, alpha: 100)
    internal static let aquamarine:     UIColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 100)
    internal static let lightcoral:     UIColor = UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 100)
    internal static let springgreen:    UIColor = UIColor(red: 0/255, green: 255/255, blue: 127/255, alpha: 100)
    internal static let darkseagreen:   UIColor = UIColor(red: 143/255, green: 188/255, blue: 143/255, alpha: 80)
    internal static let moss:           UIColor = UIColor(red: 0/255, green: 144/255, blue: 81/255, alpha: 100)
    internal static let maroon:         UIColor = UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 100)
    internal static let coral:          UIColor = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 100)
    internal static let spring:         UIColor = UIColor(red: 142/255, green: 201/255, blue: 109/255, alpha: 100)
    internal static let summer:         UIColor = UIColor(red: 0/255, green: 120/255, blue: 172/255, alpha: 100)
    internal static let fall:           UIColor = UIColor(red: 255/255, green: 229/255, blue: 178/255, alpha: 100)
    internal static let winter:         UIColor = UIColor(red: 42/255, green: 54/255, blue: 92/255, alpha: 100)
}
