//
//  JournalEntry.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import CoreData

@objc(JournalEntry)
class JournalEntry: NSManagedObject, Validatable, MetadataValidatable {
    @NSManaged public var id: UUID
    @NSManaged public var content: Data
    @NSManaged public var moodRating: Int16
    @NSManaged public var date: Date
    @NSManaged public var metadata: Data?
    
    // Helper method to add or update metadate
    func addORMetadata(key: String, value: Any) throws {
        var currentMetadata = self.getMetadata()
        currentMetadata[key] = value
        
        // Validate new metadata before updating
        let validator = MetadataValidator()
        try validator.validateMetadata(currentMetadata)
        
        // If validation passes, update metadata
        self.metadata = try JSONSerialization.data(withJSONObject: currentMetadata, options: [])
    }
    
    // Helper method to get metadata as a dictionary
    func getMetadata() -> [String: Any] {
        guard let metadata = self.metadata else { return [:]}
        return (try? JSONSerialization.jsonObject(with: metadata, options: [])) as? [String: Any] ?? [:]
    }
    
    // Validate content to ensure it is not empty
    func validateContent() throws {
        guard let contentString = String(data: content, encoding: .utf8), !contentString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw JournalError.dataIntegrityError("Content cannot be empty")
        }
    }
    
    //Validate moodRating to ensure it is within a valid range (1 to 5)
    func validateMoodRating() throws {
        guard (1...5).contains(moodRating) else {
            throw JournalError.dataIntegrityError("Mood rating must be between 1 and 5.")
        }
    }
    
    //Combining validation methods
    func validateEntry() throws {
        try validateContent()
        try validateMoodRating()
        
        // Validate existing metadata
        let validator = MetadataValidator()
        let currentMetadata = getMetadata()
        try validator.validateMetadata(currentMetadata)
    }
    
    // Method to update metadata with validation
    func updateMetadata(_ newMetadata: [String: Any]) throws {
        let validator = MetadataValidator()
        try validator.validateMetadata(newMetadata) //Validates new metadata
        self.metadata = try JSONSerialization.data(withJSONObject: newMetadata, options: [])
    }
    
    // Method to validate metadata usng the MetadataValidator
    func validateMetadata(_ metadata: [String: Any]) throws {
        let validator = MetadataValidator()
        try validator.validateMetadata(metadata)
    }
}

//For fetching entries
extension JournalEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }
}
