//
//  JournalError.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation

enum JournalError: Error, Equatable {
    case encryptionError(String)  //Error related to encryption/decryption
    case dataIntegrityError(String) // Error related to data integrity issues
    case entryNotFound //When a specific jounral entry is not found
    case unknownError(String) // General or unknown errors
    case coreDataError(String)
    
    var localizedDescription: String {
        switch self {
        case .encryptionError(let message):
            return "Encryption Error: \(message)"
        case .dataIntegrityError(let message):
            return "Data Integrity Error: \(message)"
        case .entryNotFound:
            return "The requested journal entry was not found."
        case .coreDataError(let message):
            return "Core Data Error: \(message)"
        case .unknownError(let message):
            return "Unknown Error: \(message)"
        }
    }
    
    // Conformance to Equatable
    static func ==(lhs: JournalError, rhs: JournalError) -> Bool {
        switch (lhs, rhs) {
        case (.encryptionError(let lMessage), encryptionError(let rMessage)):
            return lMessage == rMessage
        case (.dataIntegrityError(let lMessage), .dataIntegrityError(let rMessage)):
            return lMessage == rMessage
        case (.entryNotFound, .entryNotFound):
            return true
        case (.unknownError(let lMessage), .unknownError(let rMessage)):
            return lMessage == rMessage
        default:
            return false
        }
    }
}
