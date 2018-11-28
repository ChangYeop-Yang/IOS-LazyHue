//
//  CameraViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 12..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Variables
    private var imageOutputData: AVCapturePhotoOutput  = AVCapturePhotoOutput()
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var weatherIMG: UIImageView!
    @IBOutlet weak var weatherStateLB: UILabel!
    @IBOutlet weak var previewIMG: UIImageView!
    @IBOutlet weak var previewV: UIView!
    
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
            
            let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            previewLayer.frame = previewV.bounds
            previewV.layer.addSublayer(previewLayer)
            
            captureSession.addOutput(imageOutputData)
        }
    }
    
    private func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        let image: UIImage = UIImage(cgImage: cgImage, scale: 1, orientation: .right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return image
    }
    
    // MARK: - Action Method
    @IBAction func takePicture(_ sender: UIButton) {
        let settings: AVCapturePhotoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        imageOutputData.capturePhoto(with: settings, delegate: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard previewIMG.image != nil else { return }
        
        if let touch: UITouch = touches.first {
            let color: UIColor = previewIMG.getPixelColorAt(point: touch.location(in: previewIMG))
            Hue.hueInstance.changeHueColor(color: color)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            showWhisperToast(title: "Success change hue lamp color.", background: color, textColor: .white)
            print("- Current HEX Color: \(color.hexString)")
        }
    }
    
    // MARK: - Motion Method
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            previewIMG.image = nil
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

// MARK: - Delegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else {
            fatalError("- Error: Get image from camera.")
        }
        
        let image = UIImage(data: imageData)
        self.previewIMG.image = image
    }
}
