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
    @IBOutlet private weak var emptyV: UIView!
    @IBOutlet private weak var hueListTV: UITableView!
    
    // MARK: - Variables
    private var modelIDs: (set: Set<String>, arr: [String]) = ([], [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collect Model ID
        let lights = Hue.hueInstance.getHueLights().values
        for light in lights {
            self.modelIDs.set.insert(light.modelId)
            self.modelIDs.arr.append(light.modelId)
        }
        
        // MARK: Setting TableView here.
        self.hueListTV.delegate     = self
        self.hueListTV.dataSource   = self
        self.hueListTV.register(UINib(nibName: "HueTableViewCell", bundle: nil), forCellReuseIdentifier: "HueTableViewCell")
    }
    
    // MARK: - FilePrivate Method
    fileprivate func countingDuplicateItem(name: String, arr: [String]) -> Int {
        
        var bucket: (count: Int, length: Int) = (0, arr.count)
        for index in 0..<bucket.length where arr[index] == name {
            bucket.count += 1
        }
        
        return bucket.count
    }
}

// MARK: - Extension UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelIDs.set.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.modelIDs.set)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count: Int = Hue.hueInstance.getHueLights().count
        self.emptyV.isHidden = (count <= 0 ? false : true)
        
        let title: String = Array(self.modelIDs.set)[section]
        return countingDuplicateItem(name: title, arr: self.modelIDs.arr)
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

// MARK: - Extension UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
}
