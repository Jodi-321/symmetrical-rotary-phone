//
//  MetadataValidator.swift
//  journalApp
//
//  Created by admin on 9/4/24.
//

// *****WILL BE DELETED SOON****


/*
import Foundation

class MetadataValidator {
    func validate(metadata: [String: Any]) throws {
        for (key,value) in metadata {
            guard let expectedType = MetadataKeyRegistry.shared.typeForKey(key) else {
                throw MetadataValidationError.invalidKey
            }
            switch expectedType {
            case .integer:
                guard value is Int else { throw MetadataValidationError.invalidType}
            case .string:
                guard value is String else { throw MetadataValidationError.invalidType }
            case .stringArray:
                guard value is [String] else { throw MetadataValidationError.invalidType}
            }
        }
    }
}

enum MetadataValidationError: Error {
    case invalidKey
    case invalidType
}

*/
