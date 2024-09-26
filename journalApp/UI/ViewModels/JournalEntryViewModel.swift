//
//  JournalEntryViewModel.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import CoreData

class JournalEntryViewModel {
    private let journalManager: JournalManagerProtocol
    
    init(journalManager: JournalManagerProtocol) {
        self.journalManager = journalManager
    }
    
    // Fetch all entries with a completion handler
    func fetchAllEntries(completion: @escaping (Result<[JournalEntry], JournalError>) -> Void){
        journalManager.fetchEntries { result in
            // Handle the restul if needed, then pass to the caller
            completion(result)
        }
    }
    
    // Add a journal entry with a completion handler
    func addJournalEntry(content: String, moodRating: Int, completion: @escaping (Result<JournalEntry, JournalError>) -> Void) {
        journalManager.createEntry(content: content, moodRating: moodRating) { result in
            // Handler the result if needed, then pass it to the caller
            completion(result)
        }
    }
}
