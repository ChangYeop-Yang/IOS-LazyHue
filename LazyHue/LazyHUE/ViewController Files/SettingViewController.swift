//
//  SettingViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 18..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import MessageUI
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
        case gesture       = 800
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
        (IndexPath(row: 2, section: 0), "Gesture"),
        (IndexPath(row: 3, section: 0), "Delete")
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueTV = segue.destination as? UITableViewController {
            segueTV.tableView.delegate = self
            settingTV = segueTV.tableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Google Current User and Set User Image and ID here
        DispatchQueue.main.async { [unowned self] in
            if let currentUser: GIDGoogleUser = GIDSignIn.sharedInstance()?.currentUser {
                self.userNameLB.text = currentUser.profile.name
                
                if let imageData: Data = try? Data(contentsOf: currentUser.profile.imageURL(withDimension: 100)) {
                    self.userIMG.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isShowDisplay {
            isShowDisplay = false
            
            // MARK: UISwitch UserDefaults
            let arduinoSW: UISwitch = settingTV.cellForRow(at: settingTableIndexPath.first!.index)?.accessoryView as! UISwitch
            arduinoSW.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            arduinoSW.setOn(userDefault.bool(forKey: ARUDINO_ENABLE_KEY), animated: false)
            
            let motionSW: UISwitch = settingTV.cellForRow(at: settingTableIndexPath[1].index)?.accessoryView as! UISwitch
            motionSW.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            motionSW.setOn(userDefault.bool(forKey: MOTION_ENABLE_KEY), animated: false)
            
            let gestureSW: UISwitch = settingTV.cellForRow(at: settingTableIndexPath[2].index)?.accessoryView as! UISwitch
            gestureSW.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            gestureSW.setOn(userDefault.bool(forKey: GESTURE_ENABLE_KEY), animated: false)
        }
    }
    
    // MARK: - Action Method
    @objc private func switchChanged(mySwitch: UISwitch) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if let tagValue: tag = SettingViewController.tag(rawValue: mySwitch.tag) {
            
            switch tagValue {
                case .arduino :
                    userDefault.set(mySwitch.isOn, forKey: ARUDINO_ENABLE_KEY)
                    showWhisperToast(title: "Success change arduino function state.", background: .moss, textColor: .white)
                
                case .motion :
                    userDefault.set(mySwitch.isOn, forKey: MOTION_ENABLE_KEY)
                    showWhisperToast(title: "Success change motion function state.", background: .moss, textColor: .white)
                
                case .gesture :
                    userDefault.set(mySwitch.isOn, forKey: GESTURE_ENABLE_KEY)
                    showWhisperToast(title: "Success change gesture function state.", background: .moss, textColor: .white)
                
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
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    if let url: URL = URL(string: "http://yeop9657.blog.me") {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }
                case .sendEMAIL:
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    if MFMailComposeViewController.canSendMail() {
                        let mail: MFMailComposeViewController = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setSubject("Inquiry LAZYHUE inconvenient comment")
                        mail.setToRecipients(["yeop9657@outlook.com"])
                        mail.setMessageBody("Please, Input inconvenient comment.", isHTML: false)
                        present(mail, animated: true, completion: nil)
                    }
                case .opensource:
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    if let url: URL = URL(string: "http://yeop9657.blog.me/221067037683") {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
