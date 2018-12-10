//
//  DetailTableViewController.swift
//  LazyHUE
//
//  Created by 양창엽 on 03/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Private Enum
    private enum Season: Int {
        case Spring = 0
        case Summer = 1
        case Fall   = 2
        case Winter = 3
    }

    // MARK: - Outlet Variables
    @IBOutlet private weak var emptyV: UIView!
    @IBOutlet private weak var hueListTV: UITableView!
    
    // MARK: - Variables
    private var hueLights: [String: [Hue.HueLightState]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collect Model ID
        let lights = Hue.hueInstance.getHueLights().values
        for light in lights {
            
            guard let _ = self.hueLights[light.modelId] else {
                
                self.hueLights[light.modelId] = []
                self.hueLights[light.modelId]?.append(light)
                continue
            }
            
            self.hueLights[light.modelId]?.append(light)
        }
        
        // MARK: Setting TableView here.
        self.hueListTV.dataSource   = self
        self.hueListTV.register(UINib(nibName: "HueTableViewCell", bundle: nil), forCellReuseIdentifier: "HueTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hueListTV.reloadData()
    }
    
    // MARK: - FilePrivate Method
    fileprivate func sortedForHueNameASC(this: Hue.HueLightState, that: Hue.HueLightState) -> Bool {
        return this.name < that.name
    }
    
    // MARK: - Action Method
    @IBAction func changeSeasonColor(_ sender: UISegmentedControl) {
        
        guard let segmentIndex: Season = Season(rawValue: sender.selectedSegmentIndex) else {
            print("‼️ Error, Could not get Segment Index.")
            return
        }
        
        switch segmentIndex {
            case .Spring:
                Hue.hueInstance.changeHueColor(color: .spring)
                showWhisperToast(title: "⛰ Season Color - Spring", background: .spring, textColor: .white)
            case .Summer:
                Hue.hueInstance.changeHueColor(color: .summer)
                showWhisperToast(title: "🏝 Season Color - Summer", background: .summer, textColor: .white)
            case .Fall:
                Hue.hueInstance.changeHueColor(color: .fall)
                showWhisperToast(title: "🏜 Season Color - Fall", background: .fall, textColor: .black)
            case .Winter:
                Hue.hueInstance.changeHueColor(color: .winter)
                showWhisperToast(title: "🗻 Season Color - Winter", background: .winter, textColor: .white)
        }
    }
}

// MARK: - Extension UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.hueLights.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.hueLights.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.emptyV.isHidden = (Hue.hueInstance.getHueLights().count <= 0 ? false : true)
        
        let key: String = Array(self.hueLights.keys)[section]
        if let count: Int = self.hueLights[key]?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: HueTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HueTableViewCell", for: indexPath) as? HueTableViewCell else {
            fatalError("‼️ Error, Could not create Table View Cell.")
        }
        
        let type: String = Array(self.hueLights.keys)[indexPath.section]
        guard var lights: [Hue.HueLightState] = self.hueLights[type] else {
            fatalError("‼️ Error, Could not get Custom Table View Cell.")
        }
        
        lights.sort(by: sortedForHueNameASC(this:that:))
        cell.setKey(key: lights[indexPath.row].identifier)
        cell.setHueINF(name: lights[indexPath.row].name, index: indexPath.row)
        if let isOn: Bool = lights[indexPath.row].state.on { cell.setAnimation(isOn: isOn) }
    
        return cell
    }
}
