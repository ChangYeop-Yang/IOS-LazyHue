//
//  UIImage.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 26..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

// MARK: - Extension UIImage
extension UIImage {
    
    func resize(to newSize: CGSize) -> UIImage? {
        
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil
        
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))
        
        let colorspace = CGColorSpaceCreateDeviceGray()
        let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: 0)!
        
        guard let cg = self.cgImage else {
            return nil
        }
        
        bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelBuffer
    }

}

// MARK: - Extension UIImageView
extension UIImageView {
    
    func getPixelColorAt(point:CGPoint) -> UIColor{
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        
        pixel.deallocate()
        return color
    }
}
