//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation

//Define the Validatable protocol
protocol Validatable {
    func validateEntry() throws
}

enum ValidationError: Error, LocalizedError {
    case invalidContent(String)
    case invalidMoodRating(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidContent(let message):
            return message
        case .invalidMoodRating(let message):
            return message
        }
    }
}
