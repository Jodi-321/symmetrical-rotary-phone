//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation
import CoreData

// JournalManager class handling CRUD operations and validations
class JournalManager: JournalManagerProtocol {
    private let securityManager: SecurityManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    private let coreDataManager: CoreDataManager
    private let metadataValidator: MetadataValidator
    
    init(securityManager: SecurityManagerProtocol, keychainManager: KeychainManagerProtocol, coreDataManager: CoreDataManager) {
        self.securityManager = securityManager
        self.keychainManager = keychainManager
        self.coreDataManager = coreDataManager
        self.metadataValidator = MetadataValidator()
    }
    
    // Create new journal entry
    func createEntry(content: String, moodRating: Int, metadata: [String: Any]?) -> Result<JournalEntry, JournalError> {
        do {
            //validate metadata
            if let metadata = metadata {
                try metadataValidator.validateMetadata(metadata)
            }
            
            // Convert content to Data and valdate
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return .failure(.dataIntegrityError("Content cannot be empty."))
            }
            
            //Encrypt content string to Data
            let encryptedContent = try securityManager.encrypt(data: Data(content.utf8))
            
            //validate moodRating
            guard (1...5).contains(moodRating) else {
                return .failure(.dataIntegrityError("Mood rating must be between 1 and 5."))
            }
            
            //Create new JournalEntry object
            let newEntry = JournalEntry(context: coreDataManager.context)
            newEntry.id = UUID()
            newEntry.content = encryptedContent
            newEntry.moodRating = Int16(moodRating)
            newEntry.date = Date()
            
            //Add metadata
            if let metadata = metadata {
                newEntry.metadata = try JSONSerialization.data(withJSONObject: metadata, options: [])
            }
            
            // Save the entry to Core Data
            coreDataManager.saveContext()
            return .success(newEntry)
        } catch {
            return .failure(.encryptionError(error.localizedDescription))
        }
    }
    
    //Pull all journal entries with decryption
    func fetchEntries() -> [JournalEntry] {
        let entries = coreDataManager.fetchAllEntries() //get entries from Core Data
        return entries.compactMap { entry in
            do {
                let decryptedContent = try securityManager.decrypt(data: entry.content)
                entry.content = decryptedContent // Sets decrypted content back
                return entry
            } catch {
                print("Failed to decrypt content for entry \(entry.id):\(error)")
                return nil
            }
        }
    }
    
    //Update existing journal entry
    func updateEntry(entry: JournalEntry, updatedContent: String, updatedMoodRating: Int, updatedMetadata: [String: Any]?) -> Result<Bool, JournalError> {
        do {
            // Validate updated metadata
            if let updatedMetadata = updatedMetadata {
                try metadataValidator.validateMetadata(updatedMetadata)
            }
            
            // Validate updated content
            guard !updatedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return .failure(.dataIntegrityError("Content cannot be empty."))
            }
            // Validate updated moodRating
            guard (1...5).contains(updatedMoodRating) else {
                return .failure(.dataIntegrityError("Mood rating must be between 1 and 5."))
            }
            //Validate the entry before updating
            try entry.validateEntry()
            
            //Encrypt content data
            entry.content = try securityManager.encrypt(data: Data(updatedContent.utf8))
            entry.moodRating = Int16(updatedMoodRating)
            
            // Update metadata
            if let updatedMetadata = updatedMetadata {
                entry.metadata = try JSONSerialization.data(withJSONObject: updatedMetadata, options: [])
            }
            
            coreDataManager.update(entry: entry)
            return .success(true)
        } catch {
            return .failure(.encryptionError(error.localizedDescription))
        }
    }
    
    //Delete journal entry
    func deleteEntry(entry: JournalEntry) -> Result<Bool, JournalError> {
        coreDataManager.delete(entry: entry)
        return .success(true)
    }
}
