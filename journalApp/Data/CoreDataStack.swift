//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData

class CoreDataStack {
    // Singleton instance
    static let shared = CoreDataStack()
    
    private init() {} // Private init to ensure it is a singleton
    
    // Static persistent container to ensure the model is loaded only once
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JournalAppModel")
        
        // Load Persistent Stores
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Configure contexts for concurrency
        container.viewContext.automaticallyMergesChangesFromParent = true // Merges changes form background  contexts to the main context
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    // Public property to access persistent store descriptions
    public static var persistentStoreDescriptions: [NSPersistentStoreDescription] {
        return persistentContainer.persistentStoreDescriptions
    }
    
    // Public property to access managed object model
    public static var managedObjectModel: NSManagedObjectModel {
        return persistentContainer.managedObjectModel
    }
    
    //Static access to the main context
    static var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var mainContext: NSManagedObjectContext {
        return CoreDataStack.persistentContainer.viewContext
    }
    
    // Background context for heavy/batch operations
    func backgroundContext() -> NSManagedObjectContext {
        let context = CoreDataStack.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Resolves conflicts by taking values from the object with the latest changes
        return context
    }
    
    // Saves the provided context safely
    // Parameter context: The context to save
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait { // Ensure thread-safe operations
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    //Fetch all journal entries
    func fetchAllEntries() -> [JournalEntry] {
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        do {
            return try mainContext.fetch(fetchRequest)
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
    
    /*
    // Saves changes from the Main context
    func saveMainContext() {
        saveContext(mainContext)
    }
    
    // Saves changes from the Background Context
    func saveBackgroundContext() {
        saveContext(backgroundContext)
    }
    
    // Provide a static context for the main queue
    static var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Utility Methods for Thread-safe Operations
    
    // Executes a closure on the main context's thread
    // Closure to execute
    /*
    func performOnMainContext(_ block: @escaping (NSManagedObjectContext) -> Void) {
        mainContext.perform {
            block(self.mainContext)
        }
    }
     */
     
     */
    
    func performOnMainContext(_ block: @escaping (NSManagedObjectContext) -> Void) {
        mainContext.perform {
            block(self.mainContext)
        }
    }
    
    // Executes a closure on the background context's thread
    // Closure to execute
    func performOnBackgroundContext(_ block: @escaping (NSManagedObjectContext) -> Void) {
        CoreDataStack.persistentContainer.performBackgroundTask(block)
    }
}
