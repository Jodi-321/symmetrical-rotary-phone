//
//  Validatable.swift
//  journalApp
//
//  Created by admin on 9/5/24.
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
