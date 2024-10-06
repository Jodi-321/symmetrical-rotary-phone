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
    
    let persistenceController = CoreDataStack.shared
    let keychainManager = KeychainManager()
    let authenticationManager: AuthenticationManagerProtocol
    let questionManager: SecurityQuestionsProtocol
    
    init() {
        // Intializing AuthenticationManager with KeychainManager
        self.authenticationManager = AuthenticationManager(keychainManager: keychainManager)
        
        self.questionManager = SecurityQuestionManager()
        
        // Init CoreDataStack early in app lifecycle
        let _ = CoreDataStack.shared
    }

    var body: some Scene {
        WindowGroup {
            if authenticationManager.isAuthenticated {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.mainContext)
                    //.environmentObject(authenticationManager as! AuthenticationManager)
            } else {
                //This will prompt user to enter or set a pin
                PINView(authenticationManager: authenticationManager, questionManager: questionManager)
            }
        }
    }
}
