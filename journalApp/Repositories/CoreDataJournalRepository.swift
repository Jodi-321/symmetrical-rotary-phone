//
//  CoreDataJournalRepository.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//

import Foundation
import CoreData

class CoreDataJournalRepository: JournalRepository {
    private let context: NSManagedObjectContext
    
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
}
