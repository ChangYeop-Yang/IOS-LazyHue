//
//  ConnectViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 16/11/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit
import AudioToolbox

class ConnectViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var googleCV: CardView!
    @IBOutlet weak var connectCV: CardView!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: UIView Animation
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: { [unowned self] in
            self.topView.layer.borderWidth = 2
            self.topView.layer.borderColor = UIColor.white.cgColor
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: { [unowned self] in
            self.connectCV.center.x += self.view.bounds.width
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.8, options: [], animations: { [unowned self] in
            self.googleCV.center.x += self.view.bounds.width
        }, completion: nil)
    }
    
    // MARK: - Action Method
    @IBAction func connectBridge(_ sender: UIButton) {
        
        // MARK: Connecting Philips hue bridge.
        if !Hue.hueInstance.connectHueBridge() {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            showWhisperToast(title: "Please, Press bridge button.", background: .coral, textColor: .black, clock: 10)
        }
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
