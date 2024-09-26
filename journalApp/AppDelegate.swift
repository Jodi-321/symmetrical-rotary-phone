//
//  AppDelegate.swift
//  journalApp
//
//  Created by admin on 9/6/24.
//

import Foundation
import UIKit
import CoreData


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptios launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Init CoreDataStack early in the app lifecycle
        let _ = CoreDataStack.shared
        
        //Register the MetadataValueTransformer with Core Data
        //MetadataValueTransformer.register()
        
        //Continue setting up your application
        return true
    }
    
    // Core Data stack setup here soon
}
