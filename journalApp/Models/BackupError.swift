//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation

enum BackupError: Error {
    case backupFailed(String) // Error for if backup fails
    case restoreFailed(String) //Error for if restore fails
    case fileNotFound // When the backup file is not found
    case unknwonError(String) //any other errors
    
    var localizedDescription: String {
        switch self {
        case .backupFailed(let message):
            return "Backup Failed: \(message)"
        case .restoreFailed(let message):
            return "Restore Failed: \(message)"
        case .fileNotFound:
            return "The backup file was not found."
        case .unknwonError(let message):
            return "Unknown Error: \(message)"
        }
    }
}
