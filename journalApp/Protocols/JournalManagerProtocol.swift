//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData

protocol JournalManagerProtocol {
    func createEntry(content: String, moodRating: Int, completion: @escaping (Result<JournalEntry, JournalError>) -> Void)
    func fetchEntries(completion: @escaping (Result<[JournalEntry], JournalError>) -> Void)
    func updateEntry(entry: JournalEntry, updatedContent: String, updatedMoodRating: Int, completion: @escaping (Result<Bool, JournalError>) -> Void)
    func deleteEntry(entry: JournalEntry, completion: @escaping (Result<Bool, JournalError>) -> Void)
}
