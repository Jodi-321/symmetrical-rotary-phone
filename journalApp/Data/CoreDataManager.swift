//
//  CoreDataManager.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() //Singleton instance
    
    private init() {} //Private init to ensure it is a singleton
    
    //Persistent Container: The core of Core Data stack
    lazy var persistentContainer: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "journalApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Managed Object Context from the persistent container
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //Save changes in the context
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
    
    //Fetch all journal entries
    func fetchAllEntries() -> [JournalEntry] {
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch journal entries: \(error.localizedDescription)")
            return []
        }
    }
    
    //save an array of entries (used when restoring form backup)
    func save(entries: [JournalEntry]) {
        for entry in entries {
            context.insert(entry)
        }
        saveContext()
    }
    
    //Update an entry
    func update(entry: JournalEntry) {
        saveContext()
    }
    
    //Delete an entry
    func delete(entry: JournalEntry) {
        context.delete(entry)
        saveContext()
    }
}
