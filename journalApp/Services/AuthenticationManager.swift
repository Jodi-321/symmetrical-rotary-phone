//
//  File.swift
//  Services
//
//  Created by admin on 8/29/24.
//

import Foundation

class AuthenticationManager: AuthenticationManagerProtocol {
    func authenticateUser(pin: String) -> Bool {
        //Perform PIN-based authentication logic
        return true //Placeholder
    }
    
    func changePIN(newPin: String) -> Bool {
        //change pin logic
        return true //placeholder
    }
    
    func logoutUser() {
        //logic to log out user
    }
}
