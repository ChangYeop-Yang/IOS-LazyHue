//
//  GestureViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 26..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import Vision

class GestureViewController: UIViewController {
    
    // MARK: - Outlet Variables
    private var lastPoint:  CGPoint!
    private var lineSize:   CGFloat = 10
    private var lineColor:  CGColor = UIColor.white.cgColor
    private var requests = [VNRequest]()

    // MARK: - Outlet Variables
    @IBOutlet weak var gestureIMG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Setting to CoreML
        guard let visionModel = try? VNCoreMLModel(for: MNIST().model) else {
            fatalError("‼️ Can not load Vision ML model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        self.requests = [classificationRequest]
    }
    
    // MARK: - User Method
    private func scaleImage (image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    private func handleClassification (request: VNRequest, error: Error?) {
        
        guard let observations = request.results else {
            print("‼️ Error, Can not classification letter.")
            return
        }
        
        // process the ovservations
        let classifications = observations
            .compactMap( {$0 as? VNClassificationObservation} ) // cast all elements to VNClassificationObservation objects
            .filter( {$0.confidence > 0.8} ) // only choose observations with a confidence of more than 80%
            .map( {$0.identifier} ) // only choose the identifier string to be placed into the classifications array
        
        print("🆔 CoreML Classification Letter -  \(String(describing: classifications.first))")
        
        guard let indexStr: String = classifications.first, let index: Int = Int(indexStr) else {
            print("‼️ Error, Could not convert String to Int.")
            return
        }
        
        let keys: [String] = Hue.hueInstance.getHueLights().keys.compactMap( {$0} )
        if index <= keys.count && index > 0 {
            UserDefaults.standard.bool(forKey: GESTURE_ENABLE_KEY) ? Hue.hueInstance.changeHuePower(key: keys[index - 1]) : Hue.hueInstance.changeHueColor(color: Hue.hueInstance.createRandomHueColor(), brightness: 255, key: keys[index - 1])
        }
    }
    @objc private func recongnitionDigit() {
        
        let group: DispatchGroup = DispatchGroup()
        
        group.enter()
        DispatchQueue.main.async(group: group, execute: { [unowned self] in
            
            if let image: UIImage = self.gestureIMG.image {
                let scaledImage: UIImage = self.scaleImage(image: image, toSize: CGSize(width: 28, height: 28))
                let imageRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:])
                
                do { try imageRequestHandler.perform(self.requests); group.leave() }
                catch { fatalError("Error, Can not implement core ml. \(error.localizedDescription)") }
            }
            
        })
        
        group.notify(queue: .main, execute: { [unowned self] in
            self.gestureIMG.image = nil
        })
    }
    
    // MARK: - Touch Event Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        lastPoint = touches.first?.location(in: gestureIMG)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(recongnitionDigit), userInfo: nil, repeats: false)
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
