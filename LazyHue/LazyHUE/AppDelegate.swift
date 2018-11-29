//
//  AppDelegate.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 6. 20..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Variables
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Start Location Based Service
        Location.locationInstance.startLocation()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let stroyboard: UIStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        self.window?.rootViewController = stroyboard.instantiateViewController(withIdentifier: "LoginStoryboard")
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // MARK: Detect pressing Home Button.
        print("- Resign application activity mode.")
        UserDefaults.standard.set(Hue.hueInstance.hueColors.red, forKey: HUE_COLOR_RED_KEY)
        UserDefaults.standard.set(Hue.hueInstance.hueColors.blue, forKey: HUE_COLOR_BLUE_KEY)
        UserDefaults.standard.set(Hue.hueInstance.hueColors.green, forKey: HUE_COLOR_GREEN_KEY)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
