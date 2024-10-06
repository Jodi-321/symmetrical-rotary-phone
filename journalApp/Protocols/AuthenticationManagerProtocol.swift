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
    func isPINStored() -> Bool
    var isAuthenticated: Bool { get set}
    
    func areSecurityQuestionsSet() -> Bool
    func setSecurityQuestions(_ questions: [SecurityQuestion]) -> Bool
    
    func verifySecurityAnswers(_ answers: [String]) -> Bool
    func resetPIN(newPin: String, withSecurityAnswers answers: [String]) -> Bool
}
