//
//  journalAppApp.swift
//  journalApp
//
//  Created by admin on 8/28/24.
//

import SwiftUI

@main
struct journalAppApp: App {
    //Integrate the AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Init CoreDataStack early in the app lifecycle
        let _ = CoreDataStack.shared
    }
    
    let persistenceController = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.mainContext)
        }
    }
}
