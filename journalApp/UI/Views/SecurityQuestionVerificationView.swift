//
//  SecurityQuestionVerificationView.swift
//  journalApp
//
//  Created by admin on 10/6/24.
//

import Foundation
import SwiftUI
import CryptoKit

struct SecurityQuestionsVerificationView: View {
    @State private var answer1 = ""
    @State private var answer2 = ""
    @State private var answer3 = ""
    @State private var verificationFailed = false //Tracking if the verification fails
    
    var authenticationManager: AuthenticationManagerProtocol
    var questionManager: SecurityQuestionsProtocol
    
    var onSuccess: () -> Void // Called when security questions are answered correctly
    
    var body: some View {
        VStack {
            Text("Answer Security Questions")
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
            
            Button("Verify Answers") {
                let answers = [answer1, answer2, answer3]
                if authenticationManager.verifySecurityAnswers(answers) {
                    verificationFailed = false
                    onSuccess()
                } else {
                    verificationFailed = true
                }
            }
            .padding()
            
            if verificationFailed {
                Text("Incorrect answers. Please try again.")
                    .foregroundColor(.red)
                    .padding(.top)
            }
        }
        .padding()
    }
}
