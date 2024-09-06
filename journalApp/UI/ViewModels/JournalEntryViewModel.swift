//
//  JournalEntryViewModel.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation

class JournalEntryViewModel {
    private let journalManager: JournalManagerProtocol
    
    init(journalManager: JournalManagerProtocol) {
        self.journalManager = journalManager
    }
    
    func fetchAllEntries() -> [JournalEntry] {
        return journalManager.fetchEntries()
    }
    
    func addJournalEntry(content: String, moodRating: Int, metadata: [String: Any]? = nil) -> Result<JournalEntry, JournalError> {
        //Pass these arguments to 'createEntry'
        return journalManager.createEntry(content: content, moodRating: moodRating, metadata: metadata)
    }
}
