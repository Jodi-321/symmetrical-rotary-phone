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
    
    
    init(encryptionKeyProvider: EncryptionKeyProviderProtocol) {
        self.encryptionKeyProvider = encryptionKeyProvider
    }
    
    //encrypt data
    func encrypt(data: Data) throws -> Data {
        //Perform encryption logic
        do {
            let key = try encryptionKeyProvider.provideEncryptionKey().bytes //Ensure the key is in [UInt8] format
            let iv = "ivvector12345678".utf8.map { UInt8($0) } // Convert IV to [UInt8]
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) //Create AES instance
            let encryptedData = try aes.encrypt(data.bytes) //Perform encryption
            return Data(encryptedData)
        } catch {
            throw NSError(domain: "EncryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encrypt data."])
        }
    }
    
    
    //decrypt data
    func decrypt(data: Data) throws -> Data {
        //Perform decryption logic
        do {
            let key = try encryptionKeyProvider.provideEncryptionKey().bytes  //makes sure the key is in [UInt8] format
            let iv = "ivvector12345678".utf8.map { UInt8($0) } //convert IV to [UInt8]
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)  //create AES instance
            let decryptedData = try aes.decrypt(data.bytes) //Perform decryption
            return Data(decryptedData)
        } catch {
            throw NSError(domain: "DecryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrypt data."])
        }
    }
}


