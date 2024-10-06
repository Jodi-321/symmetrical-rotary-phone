//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
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
