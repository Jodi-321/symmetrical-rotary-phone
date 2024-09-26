//
//  JournalEntry+CoreDataProperties.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//
//

import Foundation
import CoreData


extension JournalEntry {
    
    // Helper method to add or update metadata
    /*
    func addOrUpdateMetadata(key: String, value: Any) throws {
        var currentMetadata = self.getMetadata()
        currentMetadata[key] = value
        
        // Validate new metadata before updating
        //let validator = MetadataValidator()
        try validator.validateMetadata(currentMetadata)
        
        
        // Use custom transformer to conver the dictionary to Data
        //let transformer = MetadataValueTransformer()
        if let transformedData = transformer.transformedValue(currentMetadata) as? Data {
            self.metadata = transformedData
        } else {
            throw MetadataValidationError.customError(message: "Failed to transform metadata to Data.")
        }
    }
    
    // Helper method to get metadata as a dictionary
    func getMetadata() -> [String: Any] {
        guard let metadata = self.metadata else { return [:]}
        
        // Use custom transformer to convert the Data to a dixctionary
        //let transformer = MetadataValueTransformer()
        if let transformedMetadata = transformer.reverseTransformedValue(metadata) as? [String: Any] {
            return transformedMetadata
        } else {
            return [:] //return an empty dictionary if trasnformation fails
        }
        //return (try? JSONSerialization.jsonObject(with: metadata, options: [])) as? [String: Any] ?? [:]
    }
     */
    
    // Validate content to ensure it is not empty
    func validateContent() throws {
        // Unwrap content to get non-optional Data
        guard let contentData = content else {
            throw JournalError.dataIntegrityError("Content is missing.")
        }
        
        // Ensure the content is non-empty string
        guard let contentString = String(data: contentData, encoding: .utf8), !contentString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            throw JournalError.dataIntegrityError("Content cannot be empty.")
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
        //try validateMoodRating()
        
        // Validate existing metadata
        //let validator = MetadataValidator()
        //let currentMetadata = getMetadata()
        //try validator.validateMetadata(currentMetadata)
    }
    
    /*
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
     */
    
}

