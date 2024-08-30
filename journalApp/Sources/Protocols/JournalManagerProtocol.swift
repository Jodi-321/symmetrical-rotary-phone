//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

Protocol JournalManagerProtocol {
    func createEntry(content: String, moodRating: Int) -> Result<JournalEntry, JournalError>
    func fetchEntries() -> [JournalEntry]
    func updateEntry(entry: JournalEntry) -> Result<Bool, JournalError>
    func deleteEntry(entry: JournalEntry) -> Result<Bool, JOurnalError>
}
