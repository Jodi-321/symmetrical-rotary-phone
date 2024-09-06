//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

protocol JournalManagerProtocol {
    func createEntry(content: String, moodRating: Int, metadata: [String: Any]?) -> Result<JournalEntry, JournalError>
    func fetchEntries() -> [JournalEntry]
    func updateEntry(entry: JournalEntry, updatedContent: String, updatedMoodRating: Int, updatedMetadata: [String: Any]?) -> Result<Bool, JournalError>
    func deleteEntry(entry: JournalEntry) -> Result<Bool, JournalError>
}
