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
    private var lineColor:  CGColor = UIColor.black.cgColor
    private var requests = [VNRequest]()

    // MARK: - Outlet Variables
    @IBOutlet weak var gestureIMG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let visionModel = try? VNCoreMLModel(for: CharacteristicsClassifier().model) else {
            fatalError("Can not load Vision ML model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        self.requests = [classificationRequest]
    }
    
    // MARK: - Method
    func scaleImage (image:UIImage, toSize size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @objc func recongnitionDigit() {
        
        
        let scaledImage = scaleImage(image: gestureIMG.image!, toSize: CGSize(width: 28, height: 28))
        let imagerRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:])
        
        do {
            try imagerRequestHandler.perform(self.requests)
        } catch { print(error) }
        
        gestureIMG.image = nil
    }
    
    func handleClassification (request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        let classifications = observations as? [VNClassificationObservation]
        
        print("ASDASDASDASD - \(classifications?.first!.identifier)")
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
