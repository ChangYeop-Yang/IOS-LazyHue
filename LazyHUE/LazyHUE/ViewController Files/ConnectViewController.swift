//
//  ConnectViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 16/11/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit
import GoogleSignIn
import AudioToolbox

class ConnectViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var googleCV: CardView!
    @IBOutlet weak var connectCV: CardView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var googleSignBT: UIButton!
    @IBOutlet weak var bridgeConnBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Google GIDSignInDelegate
        GIDSignIn.sharedInstance().clientID = "950023856140-shsbi6srb83v66ks1cu26r9a0ovju2us.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // MARK: Hue Delegate
        Hue.hueInstance.delegate = self
        
        // MARK: UIView Animation
        UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: { [unowned self] in
            self.topView.layer.borderWidth = 2
            self.topView.layer.borderColor = UIColor.white.cgColor
            }, completion: nil)
        
        // MARK: Check Philips Hue Bridge
        if !UserDefaults.standard.bool(forKey: CONNECT_BRIDGE_STATE_KEY) {
            
            UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: { [unowned self] in
                self.connectCV.isHidden = false
                self.connectCV.center.x += self.view.bounds.width
                }, completion: nil)
            UIView.animate(withDuration: 0.5, delay: 0.8, options: [], animations: { [unowned self] in
                self.googleCV.isHidden = false
                self.googleCV.center.x += self.view.bounds.width
                }, completion: nil)
        }
        else {
            Hue.hueInstance.connectHueBridge()
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    // MARK: - Action Method
    @IBAction func connectBridge(_ sender: UIButton) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // MARK: Connecting Philips hue bridge.
        Hue.hueInstance.connectHueBridge()
        showWhisperToast(title: "Please, Press bridge button.", background: .coral, textColor: .black, clock: 10)
    }
    @IBAction func loginGoogle(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

// MARK: - GIDSignInDelegate Extension
extension ConnectViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            print("⌘ Error, Google Sign - \(error.localizedDescription)")
            return
        }
        
        // Transition StoryBoard here
        if let nextController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
            self.present(nextController, animated: true, completion: nil)
        }
    }
}

// MARK: - GIDSignInUIDelegate
extension ConnectViewController: GIDSignInUIDelegate {
    
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!,
                        presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - HueDelegate
extension ConnectViewController: HueAlterDelegate {
    
    func isConnectedBridge() {
        // Perform any operations on signed in user here.
        self.googleSignBT.isEnabled = true
        self.bridgeConnBT.isEnabled = false
        showWhisperToast(title: "Success, Connect google social login.", background: .moss, textColor: .white)
    }
}
