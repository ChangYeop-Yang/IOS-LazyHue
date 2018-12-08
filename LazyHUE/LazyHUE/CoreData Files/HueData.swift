//
//  HueData.swift
//  LazyHUE
//
//  Created by 양창엽 on 04/12/2018.
//  Copyright © 2018 양창엽. All rights reserved.
//

import UIKit
import CoreData

// MARK: - File Global Variables
internal let HUE_OBJECT_COLOR_ENTITY_NAME: String = "HueColor"

class HueData: NSObject {
    
    // MARK: - Variables
    internal static let hueDataInstance: HueData = HueData()
    
    // MARK: - Private User Method
    private override init() {}
    private func getManagedContext() -> NSManagedObjectContext {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error, Could not get AppDelegate.")
        }
        
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    private func getFetchRequest(entityName: String) -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    }
    
    // MARK: - Internal User Method
    internal func createHueColorData(red: Float, green: Float, blue: Float, alpha: Float) {
        let hueColor: HueColor = HueColor(context: getManagedContext())
        hueColor.redColor   = red
        hueColor.greenColor = green
        hueColor.blueColor  = blue
        hueColor.alphaColor = alpha
        
        // Init Create Hue Color Object and Save Data
        saveCoreData()
    }
    internal func updateHueColor(entityName: String, red: Float, green: Float, blue: Float, alpha: Float) {
        
        guard let color: HueColor = fetchHueColor(entityName: entityName) else {
            return
        }
        color.redColor      = red
        color.greenColor    = green
        color.blueColor     = blue
        color.alphaColor    = alpha
        
        // Save Core Data here.
        saveCoreData()
    }
    internal func fetchHueColor(entityName: String) -> HueColor? {
        do {
            let color = try getManagedContext().fetch(getFetchRequest(entityName: entityName)) as! [HueColor]
            print("😃 Success, Could fetch core data.")
            return color.first
        }
        catch let error as NSError {
            print("😩 Error, Critical core data problem. \(error.localizedDescription)")
            return nil
        }
    }
    internal func deleteHueColor(entityName: String) {
        
        guard let object: HueColor = fetchHueColor(entityName: entityName) else {
            return
        }
        
        // Delete and Save here.
        getManagedContext().delete(object)
        saveCoreData()
    }
    internal func saveCoreData() {
        do {
            try getManagedContext().save()
            print("😃 Success, Could save core data.")
        }
        catch let error as NSError {
            print("🤬 Error, Could not save core data. \(error.localizedDescription)")
        }
    }
}
