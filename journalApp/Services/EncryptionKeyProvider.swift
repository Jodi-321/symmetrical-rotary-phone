//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import Security

class EncryptionKeyProvider: EncryptionKeyProviderProtocol {
    private let keychainManager: KeychainManagerProtocol
    private let encryptionKeyname = "com.soluMates.journalApp.encryptionKey"
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    func provideEncryptionKey() throws -> Data {
        //Retrieve encryption key securely from Keychain
        do {
            // Attempting to retrieve encrypt key from keychain
            if let keyData = try? keychainManager.retrieveKey(forKey: encryptionKeyname) {
                return keyData
            }
            // Key not found, generate a new one
            let newKey = generateEncryptionKey()
            
            // Store the new key in Keychain
            try keychainManager.storeKey(newKey, forKey: encryptionKeyname)
            
            return newKey
            
            } catch {
                throw NSError(domain: "EncryptionKeyProvider", code: 1, userInfo: [NSLocalizedDescriptionKey:"Failed to store encryption key in keychain."])
            }
        }

    private func generateEncryptionKey() -> Data {
        // Generate a random 256-bit (32-byte) key
        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        assert(result == errSecSuccess, "Failed to generate random bytes")
        return keyData
    }
}
