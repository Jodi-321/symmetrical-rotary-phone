//
//  CoreDataJournalRepository.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//

import Foundation
import CoreData

class CoreDataJournalRepository: JournalRepository {
    //private let context: NSManagedObjectContext
    
    // Use CoreDataStack's context methods
    init() {}
    
    func create(entry: JournalEntry) throws {
        CoreDataStack.shared.performOnBackgroundContext { context in
            context.insert(entry)
            do {
                try CoreDataStack.shared.saveContext(context)
            } catch {
                print("Failed to save new entry: \(error.localizedDescription)")
            }
        }
    }
    
    func update(entry: JournalEntry) throws {
        CoreDataStack.shared.performOnBackgroundContext { context in
            do {
                try CoreDataStack.shared.saveContext(context)
            } catch {
                print("Failed to update entry: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(entry: JournalEntry) throws {
        CoreDataStack.shared.performOnBackgroundContext { context in
            context.delete(entry)
            do {
                try CoreDataStack.shared.saveContext(context)
            } catch {
                print("Failed to delete entry: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchAll() throws -> [JournalEntry] {
        var entries: [JournalEntry] = []
        CoreDataStack.shared.performOnMainContext { context in
            let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
            do {
                entries = try context.fetch(request)
            } catch {
                print("Failed to fetch entries: \(error.localizedDescription)")
            }
        }
        return entries
    }
    
    // Method to create NSFetchedResultsController
    func createFetchedResultsController(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath:\JournalEntry.dateCreated, ascending: true)], predicate: NSPredicate? = nil) -> NSFetchedResultsController<JournalEntry> {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
        
    }
    
    /*
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func create(entry: JournalEntry) throws {
        context.insert(entry)
        try context.save()
    }
    
    func update(entry: JournalEntry) throws {
        try context.save()
    }
    
    func delete(entry: JournalEntry) throws {
        context.delete(entry)
        try context.save()
    }
    
    
    func fetchAll() throws -> [JournalEntry] {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        return try context.fetch(request)
    }
     */
     
}
