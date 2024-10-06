//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation
import CryptoKit
import Combine

class AuthenticationManager: ObservableObject, AuthenticationManagerProtocol {
    // publishing property to observe changes in the authetication state
    @Published var isAuthenticated: Bool = false
    
    private let keychainManager: KeychainManagerProtocol
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    // Checking if security questions are set
    func areSecurityQuestionsSet() -> Bool {
        return keychainManager.isSecurityQuestionsSet(forKey: "userSecurityQuestions")
    }
    
    // func to store security questions
    func setSecurityQuestions(_ questions: [SecurityQuestion]) -> Bool {
        do {
            try keychainManager.storeSecurityQuestions(questions, forKey: "userSecurityQuestions")
            return true
        } catch {
            print("Failed to set security questions: \(error.localizedDescription)")
            return false
        }
    }
    
    // func to verify security answers
    func verifySecurityAnswers(_ answers: [String]) -> Bool {
        do {
            let storedQuestions = try keychainManager.retrieveSecurityQuestions(forKey: "userSecurityQuestions")
            
            for (index, storedQuestion) in storedQuestions.enumerated() {
                let hashedAnswer = hashAnswer(answers[index])
                if storedQuestion.answerHash != hashedAnswer {
                    return false // Answer doesn't match
                }
            }
            return true
        } catch {
            print("Failed to retrieve security questions: \(error.localizedDescription)")
            return false
        }
    }
    
    // Hashing answers to compare
    private func hashAnswer(_ answer: String) -> String {
        let hashedData = SHA256.hash(data: Data(answer.utf8))
        return Data(hashedData).base64EncodedString()
    }
    
    // Check to ensure security questions are set before moving forward
    func ensureSecurityQuestionsAreSet() -> Bool {
        if areSecurityQuestionsSet() {
            return true
        } else {
            return false
        }
    }
    
    // CHeck if a PIN is already in keychain
    func isPINStored() -> Bool {
        do {
            //REMOVE NOT FOR PRODUCTION // checking if PIN is stored
            let _ = try keychainManager.retrieveHashedPIN(forKey: "userPIN")
            print("[DEBUG] PIN is stored.")
            return true
        } catch {
            print(";DEBUG] PIN not found: \(error.localizedDescription)")
            return false
        }
    }
    
    //Authenticate user with a pin
    func authenticateUser(pin: String) -> Bool {
        do {
            // Retrieve salt and hashed PIN
            //REMOVE NOT FOR PRODUCTION
            print("[DEBUG] Attempting to authenticate user.")
            let (salt, storedHashedPIN) = try keychainManager.retrieveHashedPIN(forKey: "userPIN")
            
            print("DEBUG] Retrieved salt: \(salt.base64EncodedString())")
            print("[DEBUG] Retrieved hashed PIN: \(storedHashedPIN.base64EncodedString())")
            
            // Hashing entered PIN with stored salt
            let enteredHashedPIN = hashPIN(pin, withSalt: salt)
            print("[DEBUG] Entered hashed PIN: \(enteredHashedPIN.base64EncodedString())")
            
            // comparison of enteredHashedPIN and storedHashedPIN
            let authenticated = enteredHashedPIN == storedHashedPIN
            self.isAuthenticated = authenticated
            if authenticated {
                print("DEBUG Authentication succesful.")
            } else {
                print("DEBUG Authentication failed. PINS do not match")
            }
            return authenticated
        } catch {
            print("Failed to retrieve stored PIN: \(error.localizedDescription)")
            return false
        }
    }
    
    //Change user PIN
    func changePIN(newPin: String) -> Bool {
        do {
            // Storing hashed new PIN with new salt
            try keychainManager.storeHashedPIN(newPin, forKey: "userPIN")
            return true
        } catch {
            print("Failed to store new PIN: \(error.localizedDescription)")
            return false
        }
    }
    
    // Reset PIN after verifying security answers
    func resetPIN(newPin: String, withSecurityAnswers answers: [String]) -> Bool {
        if verifySecurityAnswers(answers) {
            // if security answers match, allow resetting the pin
            return changePIN(newPin: newPin)
        } else {
            print("Failed to verify security answers.")
            return false
        }
    }
    
    // log out user
    func logoutUser() {
        do {
            try keychainManager.deleteKey(forKey: "userPIN")
            print("User PIN deleted from keychain")
        } catch {
            print("Failed to delete user PIN: \(error.localizedDescription)")
        }
    }
    
    // Helper to hash PIN with salt
    private func hashPIN(_ pin: String, withSalt salt: Data) -> Data {
        var hasher = SHA256()
        hasher.update(data:salt)
        hasher.update(data: Data(pin.utf8))
        return Data(hasher.finalize())
    }
}
