//
//  CoreDataManager.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//
/*
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() //Singleton instance
    
    private init() {} //Private init to ensure it is a singleton
    
    //Persistent Container: The core of Core Data stack
    lazy var persistentContainer: NSPersistentContainer =  {
        //Using base name of data model without version suffix
        let container = NSPersistentContainer(name: "JournalAppModel")
        let description = container.persistentStoreDescriptions.first
        
        // Enable lightweight migration
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
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
    func saveContext(_ context: NSManagedObjectContext) {
        //let context = persistentContainer.viewContext
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
        CoreDataStack.shared.performOnBackgroundContext { context in
            for entry in entries {
                context.insert(entry)
            }
            do {
                try CoreDataStack.shared.saveContext(context)
            } catch {
                print("Failed to save entries: \(error.localizedDescription)")
            }
        }
    }
    
    //Update an entry
    func update(entry: JournalEntry) {
        CoreDataStack.shared.performOnBackgroundContext { context in
            do {
                try CoreDataStack.shared.saveContext(context)
            } catch {
                print("Failed to update entry: \(error.localizedDescription)")
            }}
        //saveContext()
    }
    
    //Delete an entry
    func delete(entry: JournalEntry) {
        CoreDataStack.shared.performOnBackgroundContext { context in
            context.delete(entry)
            do {
                try CoreDataStack.shared.saveContext(context)
            } catch {
                print("Failed to delete entry: \(error.localizedDescription)")
            }
        }
    }
    
    // Fetch entries with specific tags (This will be for advanced analytics)
    func fetchEntries(withTags tags: [String]) -> [JournalEntry] {
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        
        // Create a predicate to filter entries by tags
        let predicate = NSPredicate(format: "ANY tags IN %@", tags)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch journal entries with tags: \(error.localizedDescription)")
            return []
        }
    }
}

*/
