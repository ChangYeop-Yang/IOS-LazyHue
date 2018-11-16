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
}
