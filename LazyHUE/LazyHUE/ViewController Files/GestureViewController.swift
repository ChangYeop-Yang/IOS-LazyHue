//
//  GestureViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 26..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit

class GestureViewController: UIViewController {
    
    // MARK: - Outlet Variables
    private var lastPoint:  CGPoint!
    private var lineSize:   CGFloat = 10
    private var lineColor:  CGColor = UIColor.black.cgColor

    // MARK: - Outlet Variables
    @IBOutlet weak var gestureIMG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Method
    @objc func recongnitionDigit() {
        
        if let image: UIImage = gestureIMG.image?.resize(to: CGSize(width: 28, height: 28)) {
            if let pixel = image.pixelBuffer(), let result = try? MNIST().prediction(image: pixel) {
                print("- Recongnition Digit: \(result.classLabel)")
            }
        }
        
        gestureIMG.image = nil
    }
    
    // MARK: - Touch Event Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        lastPoint = touches.first?.location(in: gestureIMG)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recongnitionDigit), userInfo: nil, repeats: false)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIGraphicsBeginImageContext(gestureIMG.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        if let currentPoint = touches.first?.location(in: gestureIMG) {
            gestureIMG.image?.draw(in: CGRect(x: 0, y: 0, width: gestureIMG.frame.size.width, height: gestureIMG.frame.size.height))
            
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            UIGraphicsGetCurrentContext()?.strokePath()
            
            gestureIMG.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            lastPoint = currentPoint
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIGraphicsBeginImageContext(gestureIMG.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)

        gestureIMG.image?.draw(in: CGRect(x: 0, y: 0, width: gestureIMG.frame.size.width, height: gestureIMG.frame.size.height))

        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()

        gestureIMG.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
