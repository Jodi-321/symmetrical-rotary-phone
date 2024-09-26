//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation
import Security

class KeychainManager: KeychainManagerProtocol {
    func storeKey(_ key: Data, forKey keyName: String) throws {
        //logic to securely store the key in keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecValueData as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new key to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to store key in keychain. Status code:\(status)"])
        }
    }
    
    //Retrieve key from keychain
    func retrieveKey(forKey keyName: String) throws -> Data {
        //Logic to retrieve the key from keychain
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
                throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve key from Keychain."])
            }
        } else if status == errSecItemNotFound {
            //Key not found in keychain
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Key not found in keychain. Status code: \(status)"])
        } else {
            // Other keychain errors
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve ey from keychain. Status code: \(status)"])
        }
    }
    
    //Delete key from keychain
    func deleteKey(forKey keyName: String) throws {
        //Logic to delete the key from Keychain
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
