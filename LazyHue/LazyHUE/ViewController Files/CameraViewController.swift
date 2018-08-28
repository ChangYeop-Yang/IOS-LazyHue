//
//  CameraViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 12..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import AVKit

class CameraViewController: UIViewController {

    // MARK: - Variables
    private var layerPreView: AVCaptureVideoPreviewLayer!
    
    // MARK: - IBOutlet
    @IBOutlet weak var weatherIMG: UIImageView!
    @IBOutlet weak var weatherStateLB: UILabel!
    @IBOutlet weak var preview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Weather Information
        weatherIMG.image = UIImage(named: Weather.weatherInstance.weatherData.icon)
        weatherStateLB.text = Weather.weatherInstance.weatherData.sky
        
        // MARK: Camera Preview
        previewCamera()
    }
    
    // MARK: - Method
    private func previewCamera() {
        
        let captureSession: AVCaptureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("- Error AVCapture Device.")
        }
        
        if let input = try? AVCaptureDeviceInput(device: captureDevice) {
            captureSession.addInput(input)
            captureSession.startRunning()
            
            layerPreView = AVCaptureVideoPreviewLayer(session: captureSession)
            layerPreView.videoGravity = .resizeAspectFill
            layerPreView.connection?.videoOrientation = .portrait
            layerPreView.frame = preview.bounds
            preview.layer.addSublayer(layerPreView)
            
            let dataOutPut: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
            dataOutPut.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
            captureSession.addOutput(dataOutPut)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: preview)
            print(position)
            print(layerPreView.colorOfPoint(point: layerPreView.captureDevicePointConverted(fromLayerPoint: position)))
        }
    }
    @IBAction func tapCameraPreview(_ sender: UITapGestureRecognizer) {
        
    }
}

// MARK: - Delegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
