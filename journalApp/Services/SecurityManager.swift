//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation
import CryptoSwift

class SecurityManager: SecurityManagerProtocol {
    private let encryptionKeyProvider: EncryptionKeyProviderProtocol
    
    // Class-level property to store the encryption key
    private let encryptionKey: [UInt8]
    
    
    // Initialize the key once during class instantiation
    init(encryptionKeyProvider: EncryptionKeyProviderProtocol) throws {
        self.encryptionKeyProvider = encryptionKeyProvider
        
        // Retrieve and store the key from the provider
        let keyData = try encryptionKeyProvider.provideEncryptionKey()
        
        // COnvert key to [UInt8] format
        self.encryptionKey = keyData.bytes
        
        // Log the key for verification (remove in production******
        print("Generated encryption key: \(encryptionKey.map { String(format: "%02x", $0)}.joined())")
    }
    
    //encrypt data
    func encrypt(data: Data) throws -> Data {
        //Perform encryption logic
        do {
            //Use stored encryption key
            let key = encryptionKey
            
            // Generate a random IV
            let iv = AES.randomIV(AES.blockSize) // AES.blockSize is 16 bytes for AES
            
            // Create AES instance with the random IV
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
            
            // Perform Encryption
            let encryptedBytes = try aes.encrypt(data.bytes)
            
            //Prepend the IV to the encrypted data
            var combinedData = Data(iv) //IV as Data
            combinedData.append(Data(encryptedBytes))
            
            return combinedData // Returns IV + encrypted data
            
        } catch {
            throw NSError(domain: "EncryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encrypt data. Error:\(error.localizedDescription)"])
        }
    }
    
    
    //decrypt data
    func decrypt(data: Data) throws -> Data {
        //Perform decryption logic
        do {
            //Use stored key
            let key = encryptionKey
            
            // Extract the IV and encrypted data
            let ivSize = AES.blockSize // 16 bytes for AES
            guard data.count > ivSize else {
                throw NSError(domain: "DecryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey:"Invalid data. Not enough data for IV and ciphertext"])
            }
            
            // Extract IV and encrypted content
            let ivData = data.subdata(in: 0..<ivSize)
            let encryptedData = data.subdata(in: ivSize..<data.count)
            
            let iv = ivData.bytes
            let encryptedBytes = encryptedData.bytes
            
            // Create AES instance with the extracted IV
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
            
            // Perform decryption
            let decryptedData = try aes.decrypt(encryptedBytes)
            
            return Data(decryptedData)
        } catch {
            throw NSError(domain: "DecryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrypt data. Error:\(error.localizedDescription)"])
        }
    }
}


