//
//  CameraViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 12..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import Vision
import AVKit
import AudioToolbox
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: Enum
    private enum ImageMoodType: String {
        case Detailed = "Detailed"
        case Pastel = "Pastel"
        case Melancholy = "Melancholy"
        case Noir = "Noir"
        case HDR = "HDR"
        case Vintage = "Vintage"
        case LongExposure = "Long Exposure"
        case Horror = "Horror"
        case Sunny = "Sunny"
        case Bright = "Bright"
        case Hazy = "Hazy"
        case Bokeh = "Bokeh"
        case Serene = "Serene"
        case Texture = "Texture"
        case Ethereal = "Ethereal"
        case Macro = "Macro"
        case DepthOfField = "Depth of Field"
        case GeometricComposition = "Geometric Composition"
        case Minimal = "Minimal"
        case Romantic = "Romantic"
    }
    
    // MARK: - Variables
    private var requests = [VNRequest]()
    private var cameraType: Bool = false
    private var priviousType: String = ""
    private var imageOutputData: AVCapturePhotoOutput  = AVCapturePhotoOutput()
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var weatherIMG: UIImageView!
    @IBOutlet weak var weatherStateLB: UILabel!
    @IBOutlet weak var outsideRoundV: RoundView!
    @IBOutlet weak var previewIMG: UIImageView!
    @IBOutlet weak var previewV: UIView!
    @IBOutlet weak var photoInformationV: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Weather Information
        weatherIMG.image = UIImage(named: Weather.weatherInstance.weatherData.icon)
        weatherStateLB.text = Weather.weatherInstance.weatherData.sky
        
        // MARK: Camera Preview
        previewCamera()
        
        // MARK: Setting to CoreML
        guard let visionModel = try? VNCoreMLModel(for: FlickrStyle().model) else {
            fatalError("Can not load Vision ML model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        self.requests = [classificationRequest]
    }
    
    // MARK: - Private User Method
    private func previewCamera() {
        
        let captureSession: AVCaptureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("- Error AVCapture Device.")
        }
        
        if let input = try? AVCaptureDeviceInput(device: captureDevice) {
            captureSession.addInput(input)
            captureSession.startRunning()
            
            // AVCaptureVideoPreviewLayer
            let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            previewLayer.frame = previewV.bounds
            previewV.layer.addSublayer(previewLayer)
            
            // AVCaptureVideoDataOutput
            let dataOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

            captureSession.addOutput(dataOutput)
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
    private func handleClassification (request: VNRequest, error: Error?) {
        
        guard let observations = request.results else {
            print("Error, Can not classification letter.")
            return
        }
        
        // process the ovservations
        let classifications = observations
            .compactMap( {$0 as? VNClassificationObservation} ) // cast all elements to VNClassificationObservation objects
            .filter( {$0.confidence > 0.6} ) // only choose observations with a confidence of more than 60%
            .map( {$0.identifier} ) // only choose the identifier string to be placed into the classifications array
        
        if let moodType: String = classifications.first, let type: ImageMoodType = ImageMoodType(rawValue: moodType) {
            
            // Check duplicate value
            guard moodType != priviousType else { return }
            
            priviousType = moodType
            print("⌘ CoreML Classification Letter -  \(moodType)")
            
            switch type {
                case .Sunny: Hue.hueInstance.changeHueColor(color: .red)
                case .Romantic: Hue.hueInstance.changeHueColor(color: .lightcoral)
                default: break
            }
        }
    }
    
    // MARK: - Action Method
    @IBAction func takePicture(_ sender: UIButton) {
        let settings: AVCapturePhotoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        imageOutputData.capturePhoto(with: settings, delegate: self)
    }
    @IBAction func changeCameraFuncation(_ sender: UISegmentedControl) {
        
        let isSwiched: (photo: Int, camera: Int) = (0, 1)

        if isSwiched.photo == sender.selectedSegmentIndex {
            self.cameraType = false
            self.outsideRoundV.isHidden = false
        }
        else if isSwiched.camera == sender.selectedSegmentIndex {
            self.cameraType = true
            self.outsideRoundV.isHidden = true
        }
    }
    
    
    // MARK: - Touch Event Method
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
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            self.previewIMG.image = nil
            self.photoInformationV.isHidden = true
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate Delegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else {
            fatalError("- Error: Get image from camera.")
        }
        
        let image = UIImage(data: imageData)
        self.previewIMG.image = image
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.photoInformationV.isHidden = false
            self.photoInformationV.center.y -= self.view.bounds.height
        }, completion: nil)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBuffer Delegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Enable Real-Time Camera Funcation
        if self.cameraType {
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            DispatchQueue.main.async { [unowned self] in
                do { try imageRequestHandler.perform(self.requests); }
                catch { fatalError("Error, Can not implement core ml. \(error.localizedDescription)") }
            }
        }
    }
}
