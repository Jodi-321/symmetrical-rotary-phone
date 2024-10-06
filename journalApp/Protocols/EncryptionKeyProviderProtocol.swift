//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation

protocol EncryptionKeyProviderProtocol {
    func provideEncryptionKey() throws -> Data
}
