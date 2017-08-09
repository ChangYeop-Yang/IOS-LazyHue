//
//  BasicEvent.swift
//  LazyHue
//
//  Created by 양창엽 on 2017. 8. 8..
//  Copyright © 2017년 Yang-Chang-Yeop. All rights reserved.
//

import SwiftyHue    /* Philips Hue API */
import Foundation

/* MARK - Notification Event Protocol */
protocol NotificationEvent
{
    /* POINT - Notification Type Method */
    func pressHomeKey(swiftyHue:SwiftyHue)
}
