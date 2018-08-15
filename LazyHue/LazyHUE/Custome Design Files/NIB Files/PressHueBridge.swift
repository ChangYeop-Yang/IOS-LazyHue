//
//  PressHueBridge.swift
//  SAIOT
//
//  Created by 양창엽 on 2018. 5. 3..
//  Copyright © 2018년 Yang-Chang-Yeop. All rights reserved.
//

import UIKit

class PressHueBridge: UIView {
    
    // MARK: - Outlet Variable
    @IBOutlet weak var timerProgress: UIProgressView!
    
    // MARK: - Variable
    private var pressTimer: Timer = Timer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.black.cgColor
        
        pressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePressTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - Method
    @objc private func updatePressTimer() {
        
        if timerProgress.progress >= 1 {
            pressTimer.invalidate()
            self.removeFromSuperview()
        }
        
        timerProgress.progress += 0.1
    }
}
