//
//  UIColor.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 11..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

extension UIColor {
    
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
    internal static let aquamarine: UIColor = UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 100)
    internal static let lightcoral: UIColor = UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 100)
    internal static let springgreen: UIColor = UIColor(red: 0/255, green: 255/255, blue: 127/255, alpha: 100)
    internal static let darkseagreen: UIColor = UIColor(red: 143/255, green: 188/255, blue: 143/255, alpha: 80)
    internal static let moss: UIColor = UIColor(red: 0/255, green: 144/255, blue: 81/255, alpha: 100)
    internal static let maroon: UIColor = UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 100)
    internal static let coral: UIColor = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 100)
}
