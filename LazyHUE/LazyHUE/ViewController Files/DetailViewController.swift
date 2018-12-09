//
//  DetailTableViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 03/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlet Variables
    @IBOutlet weak var emptyV: UIView!
    @IBOutlet weak var hueListTV: UITableView!
    
    // MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Setting TableView here.
        self.hueListTV.delegate     = self
        self.hueListTV.dataSource   = self
    }
}

// MARK: -
extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count: Int = Hue.hueInstance.getHueLights().count
        self.emptyV.isHidden = (count <= 0 ? false : true)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: HueTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HueTableViewCell", for: indexPath) as? HueTableViewCell else {
            fatalError("‼️ Error, Could not create Table View Cell.")
        }
        cell.setIndexPath(index: indexPath.row)
        cell.initHueCell()
        
        return cell
    }
}

// MARK: -
extension DetailViewController: UITableViewDelegate {
    
}
