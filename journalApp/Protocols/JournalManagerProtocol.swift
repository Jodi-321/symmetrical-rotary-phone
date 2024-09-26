//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation
import CoreData

protocol JournalManagerProtocol {
    func createEntry(content: String, moodRating: Int, completion: @escaping (Result<JournalEntry, JournalError>) -> Void)
    func fetchEntries(completion: @escaping (Result<[JournalEntry], JournalError>) -> Void)
    func updateEntry(entry: JournalEntry, updatedContent: String, updatedMoodRating: Int, completion: @escaping (Result<Bool, JournalError>) -> Void)
    func deleteEntry(entry: JournalEntry, completion: @escaping (Result<Bool, JournalError>) -> Void)
}
