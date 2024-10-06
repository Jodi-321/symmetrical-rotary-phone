//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

/*
import Foundation


//Enum to define possible erors in metadata validation
enum MetadataValidationError: Error, LocalizedError {
    case invalidKey
    case invalidType
    case customError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidKey:
            return "The metadata key is invalid."
        case .invalidType:
            return "The metadata type is invalid."
        case .customError(let message):
            return message
        }
    }
}

/* MAY NOT NEED THIS
// Protocol defining validation capability
protocol MetadataValidatable {
    func validate(metadata: [String: Any]) throws
}
 */


// Class to validate metadata against the allowed keys and types
class MetadataValidator: MetadataValidatable {
    private let registry = MetadataKeyRegistry.shared
    
    // Validates the provided metadata against allowed keys and types
    func validateMetadata(_ metadata: [String: Any]) throws {
        for (key, value) in metadata {
            //Check if key is allowed
            guard registry.isKeyAllowed(key) else {
                throw MetadataValidationError.invalidKey
            }
            
            // Validate the value type for the key
            if let expectedType = registry.typeForKey(key) {
                switch expectedType {
                case .string:
                    guard value is String else { throw MetadataValidationError.invalidType}
                case .integer:
                    guard value is Int else { throw MetadataValidationError.invalidType }
                case .stringArray:
                    guard value is [String] else { throw MetadataValidationError.invalidType }
                case .date:
                    guard value is Date else { throw MetadataValidationError.invalidType }
                }
            }
        }
    }
    
    func addCustomValidationRule(forKey key: String, validationBlock: @escaping (Any) -> Bool) {
        //Custom vaidation logic will go here. 
    }
}

*/
