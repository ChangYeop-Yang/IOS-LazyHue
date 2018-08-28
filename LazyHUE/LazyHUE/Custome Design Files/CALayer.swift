//
//  CALayer.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 27..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

extension CALayer {
    
    func colorOfPoint(point: CGPoint) -> UIColor {
        
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.translateBy(x: -point.x, y: -point.y)
        
        self.render(in: context!)
        
        let red:    CGFloat = CGFloat(pixel[0]) / 255.0
        let green:  CGFloat = CGFloat(pixel[1]) / 255.0
        let blue:   CGFloat = CGFloat(pixel[2]) / 255.0
        let alpha:  CGFloat = CGFloat(pixel[3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
