//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation

protocol KeychainManagerProtocol {
    func storeKey(_ key: Data, forKey keyName: String) throws
    func retrieveKey(forKey keyName: String) throws -> Data
    func deleteKey(forKey keyName: String)throws
    func storeHashedPIN(_ pin: String, forKey keyName: String) throws
    func retrieveHashedPIN(forKey keyName: String) throws -> (salt: Data, hashedPIN: Data)
    
    func storeSecurityQuestions(_ questions: [SecurityQuestion], forKey keyName: String) throws
    func retrieveSecurityQuestions(forKey keyName: String) throws -> [SecurityQuestion]
    func isSecurityQuestionsSet(forKey keyName: String) -> Bool
}
