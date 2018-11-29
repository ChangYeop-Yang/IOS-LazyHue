//
//  RoundButton.swift
//  LazyHUE
//
//  Created by 양창엽 on 29/11/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    override func layoutSubviews() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
