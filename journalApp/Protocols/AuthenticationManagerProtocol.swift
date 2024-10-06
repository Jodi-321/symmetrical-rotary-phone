//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
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
