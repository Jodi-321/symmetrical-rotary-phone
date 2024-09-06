//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

protocol AuthenticationManagerProtocol {
    func authenticateUser(pin: String) -> Bool
    func changePIN(newPin: String) -> Bool
    func logoutUser()
}
