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
            kSecValueData as String: key
        ]
        SecItemDelete(query as CFDictionary) //delete any existing item
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to store key in keychain."])
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
        if status != errSecSuccess {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve key from Keychain."])
        }
        return (item as! Data)
    }
    
    //Delete key from keychain
    func deleteKey(forKey keyName: String) throws {
        //Logic to delete the key from Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to delete key from keychain."])
        }
    }
}
