//
//  SettingViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 18..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import MessageUI
import SwiftSpinner
import AudioToolbox
import GoogleSignIn

@IBDesignable
class SettingViewController: UIViewController {
    
    // MARK: - Enum
    private enum tag: Int {
        case developerINFO = 100
        case sendEMAIL     = 200
        case opensource    = 300
        case arduino       = 500
        case motion        = 600
        case google        = 700
    }
    
    // MARK: - Typealias
    private typealias Index = (index: IndexPath, name: String)

    // MARK: - Outlet Variables
    @IBOutlet weak var userIMG: UIImageView!
    @IBOutlet weak var userNameLB: UILabel!
    
    // MARK: - Variables
    private var isShowDisplay: Bool = true
    private var settingTV: UITableView!
    private let userDefault: UserDefaults = UserDefaults.standard
    private let settingTableIndexPath: [Index] = [
        (IndexPath(row: 0, section: 0), "Arduino"),
        (IndexPath(row: 1, section: 0), "Motion"),
        (IndexPath(row: 0, section: 3), "Google")
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueTV = segue.destination as? UITableViewController {
            segueTV.tableView.delegate = self
            settingTV = segueTV.tableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Google GIDSignInDelegate
        GIDSignIn.sharedInstance().clientID = "950023856140-shsbi6srb83v66ks1cu26r9a0ovju2us.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if userDefault.bool(forKey: GOOGLE_ENABLE_KEY) { GIDSignIn.sharedInstance().signIn() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isShowDisplay {
            isShowDisplay = false
            
            // MARK: UserDefaults
            let arduinoSW: UISwitch = settingTV.cellForRow(at: settingTableIndexPath.first!.index)!.accessoryView as! UISwitch
            arduinoSW.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
            arduinoSW.setOn(userDefault.bool(forKey: ARUDINO_ENABLE_KEY), animated: false)
            
            let motionSW: UISwitch = settingTV.cellForRow(at: settingTableIndexPath[1].index)?.accessoryView as! UISwitch
            motionSW.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
            motionSW.setOn(userDefault.bool(forKey: MOTION_ENABLE_KEY), animated: false)
        }
    }
    
    // MARK: - Action Method
    @objc private func switchChanged(mySwitch: UISwitch) {
        
        AudioServicesPlaySystemSound(4095)
        if let tagValue: tag = SettingViewController.tag(rawValue: mySwitch.tag) {
            switch tagValue {
                
                case .arduino :
                    userDefault.set(mySwitch.isOn, forKey: ARUDINO_ENABLE_KEY)
                    showWhisperToast(title: "Success change arduino function state.", background: .moss, textColor: .white)
                
                case .motion :
                    userDefault.set(mySwitch.isOn, forKey: MOTION_ENABLE_KEY)
                    showWhisperToast(title: "Success change motion function state.", background: .moss, textColor: .white)
                
                default: break
            }
        }
    }
}

// MARK: - UITableViewDelegate Extension
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let tagVal: Int = tableView.cellForRow(at: indexPath)?.tag, let tagNum = tag(rawValue: tagVal) {
            switch tagNum {
                case .developerINFO:
                    AudioServicesPlaySystemSound(4095)
                    if let url: URL = URL(string: "http://yeop9657.blog.me") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                case .sendEMAIL:
                    AudioServicesPlaySystemSound(4095)
                    if MFMailComposeViewController.canSendMail() {
                        let mail: MFMailComposeViewController = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setSubject("Inquiry SAIOT inconvenient comment")
                        mail.setToRecipients(["yeop9657@outlook.com"])
                        mail.setMessageBody("Please, Input inconvenient comment.", isHTML: false)
                        present(mail, animated: true, completion: nil)
                    }
                case .opensource:
                    AudioServicesPlaySystemSound(4095)
                    if let url: URL = URL(string: "http://yeop9657.blog.me/221067037683") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                case .google:
                    AudioServicesPlaySystemSound(4095)
                    if userDefault.bool(forKey: GOOGLE_ENABLE_KEY) {
                        GIDSignIn.sharedInstance().signOut()
                        userDefault.set(false, forKey: GOOGLE_ENABLE_KEY)
                        showWhisperToast(title: "Success, Disconnect google social login.", background: .moss, textColor: .white)
                    } else {
                        GIDSignIn.sharedInstance().signIn()
                    }
                default: break
            }
        }
    }
}

// MARK: - MFMailComposeViewController Delegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("Success E-mail send to developer.")
        case .cancelled:
            print("Cancel E-mail send to developer.")
        case .saved:
            print("Save E-mail content into disk.");
        case .failed:
            print("Fail E-mail send to developer.")
        }
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

// MARK: - GIDSignInUIDelegate
extension SettingViewController: GIDSignInUIDelegate {
    
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

// MARK: - GIDSignInDelegate Extension
extension SettingViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        userDefault.set(true, forKey: GOOGLE_ENABLE_KEY)
        showWhisperToast(title: "Success, Connect google social login.", background: .moss, textColor: .white)
        
        DispatchQueue.main.async(execute: { [unowned self] in
            if let imageData: Data = try? Data(contentsOf: user.profile.imageURL(withDimension: 400)) {
                self.userNameLB.text = user.profile.email
                self.userIMG.image = UIImage(data: imageData)
            }
        })
    }
}
