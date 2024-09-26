//
//  FetchedResultsControllerDelegate.swift
//  journalApp
//
//  Created by admin on 9/7/24.
//

import Foundation
import CoreData
import Combine

class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    @Published var journalEntries: [JournalEntry] = []
    private var fetchedResultsController: NSFetchedResultsController<JournalEntry>
    
    init(fetchedResultsController: NSFetchedResultsController<JournalEntry>) {
        self.fetchedResultsController = fetchedResultsController
        super.init()
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            self.journalEntries = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch journal entries: \(error.localizedDescription)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedEntries = controller.fetchedObjects as? [JournalEntry] {
            self.journalEntries = updatedEntries
        }
    }
}
