//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import Security
import CryptoKit

class KeychainManager: KeychainManagerProtocol {
    // Store Security Questions
    func storeSecurityQuestions(_ questions: [SecurityQuestion], forKey keyName: String) throws {
        let serializedData = try JSONEncoder().encode(questions)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecValueData as String: serializedData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new security questions to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to store security questions in Keychain. Status code: \(status)"])
        }
    }
    
    //Retrieve Security Questions
    func retrieveSecurityQuestions(forKey keyName: String) throws -> [SecurityQuestion] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data {
                return try JSONDecoder().decode([SecurityQuestion].self, from: data)
            } else {
                throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve security questions from keychain."])
            }
        } else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve security questions. Status code: \(status)"])
        }
    }
    
    // Check if security questions are set
    func isSecurityQuestionsSet(forKey keyName: String) -> Bool {
        do {
            _ = try retrieveSecurityQuestions(forKey: keyName)
            return true
        } catch {
            return false
        }
    }
    
    // Generate a secure salt for hashing
    private func generateSalt() -> Data {
        var salt = Data(count: 16)
        
        let result = salt.withUnsafeMutableBytes { bufferPointer in
            guard let baseAddress = bufferPointer.baseAddress else {
                return Int32(-1)
            }
            return SecRandomCopyBytes(kSecRandomDefault, bufferPointer.count, baseAddress)
        }
        
        // Checking for succesful byte generation
        assert(result == errSecSuccess, "Failed to generate random salt")
        return salt
    }
    
    // Hash a PIN with the given salt using SHA-256
    private func hashPIN(_ pin: String, withSalt salt: Data) -> Data {
        var hasher = SHA256()
        hasher.update(data: salt)
        hasher.update(data: Data(pin.utf8))
        
        //REMOVE NOT FOR PRODUCTION
        let hashedPIN = Data(hasher.finalize())
        print("DEBUG] Hashed PIN: \(hashedPIN.base64EncodedString())")
        return Data(hasher.finalize())
    }
    
    func storeHashedPIN(_ pin: String, forKey keyName: String) throws {
        let salt = generateSalt()
        let hashedPIN = hashPIN(pin, withSalt: salt)
        
        // Store salt and hashed PIN together: salt:hashedPIN
        let saltAndHashedPIN = salt + hashedPIN
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecValueData as String: saltAndHashedPIN,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new hashed PIN to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to store hashed PIN in keychain. Status code: \(status)"])
        }
    }
    
    func retrieveHashedPIN(forKey keyName: String) throws -> (salt: Data, hashedPIN: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data {
                let salt = data.prefix(16)
                let hashedPIN = data.suffix(32)
                
                //REMOVE NOT FOR PRODUCTION
                print("[DEBUG] Retrieved salt: \(salt.base64EncodedString())")
                print("[DEBUG] Retrieved hashed PIN: \(hashedPIN.base64EncodedString())")
                
                return (salt: salt, hashedPIN: hashedPIN)
            } else {
                //REMOVE NOT FOR PRODUCTION
                print("[DEBUG] Failed to retrieve data from keychain.")
                
                throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve hashed PIN from keychain."])
            }
        } else if status == errSecItemNotFound {
            //REMOVE NOT FOR PRODUCTION
            print("[DEBUG] Hashed PIN not found in keychain.")
            
            // Key not found in keychain
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Hashed PIN not found in keychain. Status code: \(status)"])
        } else {
            //REMOVE NOT FOR PRODUCTION
            print("[DEBUG] Failed to retrieve hashed PIN from keychain. Status: \(status)")
            
            // Other keychain errors
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve hashed PIN from keychain. Status code: \(status)"])
        }
    }
    
    // func for storing journalEncryptionKey in Keychain
    func storeKey(_ key: Data, forKey keyName: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecValueData as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new key to keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to store key in keychain. Status code:\(status)"])
        }
    }
    
    // Retrieve encrypotionKey stored in keychain
    func retrieveKey(forKey keyName: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let data = item as? Data {
                return data
            } else {
                throw NSError(domain: "KeychainError", code: Int(status), userInfo:[NSLocalizedDescriptionKey: "Failed to retrieve key from Keychain."])
            }
        } else if status == errSecItemNotFound {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Key not found in keychain. Status code: \(status)"])
        } else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve key from keychain. Status code:\(status)"])
        }
    }
    
    
    //Delete key from keychain
    func deleteKey(forKey keyName: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to delete key from keychain. Status code: \(status)"])
        }
    }
}
