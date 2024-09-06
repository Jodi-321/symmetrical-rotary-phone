//
//  EncryptionKeyProvider.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation

class EncryptionKeyProvider: EncryptionKeyProviderProtocol {
    private let keychainManager: KeychainManagerProtocol
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    func provideEncryptionKey() throws -> Data {
        //Retrieve encryption key securely from Keychain
        return try keychainManager.retrieveKey(forKey: "encryptionKey")
    }
}
