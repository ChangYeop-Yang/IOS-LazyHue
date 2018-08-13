//
//  CameraViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 12..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    // MARK: - Variables
    private var session: AVCaptureSession?
    private var stillImageOutput: AVCaptureStillImageOutput?
    private var previewLayout: AVCaptureVideoPreviewLayer?
    
    // MARK: - IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Delegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
}
