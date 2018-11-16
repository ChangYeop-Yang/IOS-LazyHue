//
//  ConnectViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 16/11/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.clipsToBounds = true;
            topView.layer.masksToBounds = true
            topView.layer.cornerRadius = 10
            topView.layer.borderWidth = 2
            topView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
