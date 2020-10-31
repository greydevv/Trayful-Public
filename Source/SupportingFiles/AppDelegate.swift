//
//  AppDelegate.swift
//  Trayful
//
//  Created by Greyson Murray on 11/30/19.
//  Copyright © 2019 Greyson Murray. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["bb120b12f329141e73c2a5f778ff1c42"]
        
        // Handles themes
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "dark") != nil) {
            let theme: ThemeProtocol = (defaults.bool(forKey: "dark")) ? DarkTheme() : LightTheme()
            ThemeManager.setCurrent(theme: theme)
        }
        let signatureColor: UIColor = UIColor(red: 43/255, green: 156/255, blue: 255/255, alpha: 1)
        ThemeManager.setAppSignature(color: signatureColor)
        
        return true
    }
    

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

