//
//  SecurityQuestionView.swift
//  journalApp
//
//  Created by admin on 10/6/24.
//

import SwiftUI
import CryptoKit

struct SecurityQuestionView: View {
    @State private var answer1 = ""
    @State private var answer2 = ""
    @State private var answer3 = ""
    
    var authenticationManager: AuthenticationManagerProtocol
    var questionManager: SecurityQuestionsProtocol
    
    var onComplete: () -> Void // THis is called when questions are set
    
    var body: some View {
        VStack {
            Text("Set Security Questions")
                .font(.headline)
            
            Text(questionManager.getSecurityQuestions()[0])
                .padding(.top)
            
            SecureField("Answer", text: $answer1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(questionManager.getSecurityQuestions()[1])
                .padding(.top)
            
            SecureField("Answer", text: $answer2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text(questionManager.getSecurityQuestions()[2])
                .padding(.top)
            
            SecureField("Answer", text: $answer3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save Security Questions") {
                let questions = [
                    SecurityQuestion(question: questionManager.getSecurityQuestions()[0], answerHash: hashAnswer(answer1)),
                    SecurityQuestion(question: questionManager.getSecurityQuestions()[1], answerHash: hashAnswer(answer2)),
                    SecurityQuestion(question: questionManager.getSecurityQuestions()[2], answerHash: hashAnswer(answer3))
                ]
                
                if authenticationManager.setSecurityQuestions(questions) {
                    onComplete()
                }
            }
            .padding()
        }
        .padding()
    }
    private func hashAnswer( _ answer:  String) -> String {
        let hashedData = SHA256.hash(data: Data(answer.utf8))
        return Data(hashedData).base64EncodedString()
    }
}


