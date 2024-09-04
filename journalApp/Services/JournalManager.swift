//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation

class JournalManager: JournalManagerProtocol {
    private let securityManager: SecurityManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    private let coreDataManager: CoreDataManager
    
    init(securityManager: SecurityManagerProtocol, keychainManager: KeychainManagerProtocol, coreDataManager: CoreDataManager) {
        self.securityManager = securityManager
        self.keychainManager = keychainManager
        self.coreDataManager = coreDataManager
    }
    
    func createEntry(content: String, moodRating: int) -> Result<JournalEntry, JournalError> {
        do {
            let encryptedContent = try securityManager.encrypt(data: Data(content.utf8))
        } catch {
            return .failure(.encryptionError(error.localizedDescription))
        }
    }
    
    func fetchEntries() -> [JournalEntry] {
        return []
    }
    
    func updateEntry(entry: JournalEntry) -> Result<Bool, JournalError> {
        return .success(true)
    }
    
    func deleteEntry(entry: JournalEntry) -> Result<Bool, JournalError> {
        return .success(true)
    }
}
