//
//  WhisperToast.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 11..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import Whisper

// MARK: - Method
public func showWhisperToast(title: String, background: UIColor, textColor: UIColor) {
    
    var message: Murmur = Murmur(title: title)
    message.backgroundColor = background
    message.titleColor = textColor
    message.font = .boldSystemFont(ofSize: 11)
    
    Whisper.show(whistle: message, action: .show(1))
}

public func showWhisperToast(title: String, background: UIColor, textColor: UIColor, clock: Int) {
    
    var message: Murmur = Murmur(title: title)
    message.backgroundColor = background
    message.titleColor = textColor
    message.font = .boldSystemFont(ofSize: 11)
    
    Whisper.show(whistle: message, action: .show(TimeInterval(clock)))
}
