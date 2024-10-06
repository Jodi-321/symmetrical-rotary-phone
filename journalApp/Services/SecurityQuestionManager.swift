//
//  SecurityQuestionManager.swift
//  journalApp
//
//  Created by admin on 10/6/24.
//

import Foundation

struct SecurityQuestionManager: SecurityQuestionsProtocol {
    // Static security questions to be used in this app
    static let questions: [String] = [
        "What is your mother's maiden name?",
        "What was the name of your first pet?",
        "What was the name of the street you grew up on?"
    ]
    
    // Conforming to SecurityQuestionsProtocol
    func getSecurityQuestions() -> [String] {
        return SecurityQuestionManager.questions
    }
}
