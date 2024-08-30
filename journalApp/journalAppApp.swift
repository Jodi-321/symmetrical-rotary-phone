//
//  journalAppApp.swift
//  journalApp
//
//  Created by admin on 8/28/24.
//

import SwiftUI

@main
struct journalAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
