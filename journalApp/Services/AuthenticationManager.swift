//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation

class AuthenticationManager: AuthenticationManagerProtocol {
    private let keychainManager: KeychainManagerProtocol
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    //Authenticate user with a pin
    func authenticateUser(pin: String) -> Bool {
        do {
            let storedPinData = try keychainManager.retrieveKey(forKey:"userPIN")
            let storedPin = String(data: storedPinData, encoding: .utf8)
            return pin == storedPin
        } catch {
            print("Failed to retrieve stored PIN: \(error.localizedDescription)")
            return false
        }
    }
        
    //Change user PIN
    func changePIN(newPin: String) -> Bool {
        do {
            let pinData = Data(newPin.utf8)
            try keychainManager.storeKey(pinData, forKey: "userPIN")
            return true
        } catch {
            print("Failed to store new PIN: \(error.localizedDescription)")
            return false
        }
    }
    
    // log out user
    func logoutUser() {
        //clear any user session data
        print("User logged out") //temporary, need to flesh out. 
    }
}
