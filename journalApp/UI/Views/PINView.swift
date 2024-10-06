//
//  PINView.swift
//  journalApp
//
//  Created by admin on 10/5/24.
//

import Foundation
import SwiftUI
import CoreData

struct PINView: View {
    @State private var pin = ""
    @State private var newPin = ""
    @State private var showSetPIN = false
    @State private var authenticationFailed = false // Tracking if authentication fails
    @State private var pinSetupFailed = false // Tracking if PIN setup fails
    @State private var isAuthenticated = false // Tracking if authentication was succesful
    @State private var failedAttempts = 0 // Tracking the number of failed login attempts
    @State private var isLockedOut = false // Tracking is lock out is true or false
    @State private var setLockoutTimer = 30 // cooldown after lockout in seconds
    @State private var timer: Timer? // Timer for the lockout cooldown
    
    @State private var showSecurityQuestions = false // show security questiosn setup if security questiosn aren't detected'
    @State private var showVerifySecurityQuestions = false
    @State private var isForgotPIN = false // Tracking if the user clicks forgot pin
    @State private var isResettingPIN = false // Tracking if the user is allowed to reset PIN after answering security questions
    
    var authenticationManager: AuthenticationManagerProtocol
    var questionManager: SecurityQuestionsProtocol
    
    var body: some View {
        NavigationView {
            VStack {
                // PIN setup flow
                if showSetPIN {
                    // set PIN prompt will show if no PIN exists
                    Text("Set a new PIN.")
                        .font(.headline)
                    
                    TextField("Enter new PIN", text: $pin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                    
                    Button("Set PIN") {
                        if authenticationManager.changePIN(newPin: pin) {
                            showSetPIN = false
                            pin = ""
                            pinSetupFailed = false
                            
                            // Check if security questions are set
                            if !authenticationManager.areSecurityQuestionsSet() {
                                showSecurityQuestions = true
                            }
                            
                        } else {
                            // Show error message if PIN setup fails
                            pinSetupFailed = true
                            print("Failed to set PIN") //**future**
                        }
                    }
                    .padding()
                    
                    if pinSetupFailed {
                        Text("Failed to set PIN. Try again.")
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                } 
                
                // Security Questions flow
                else if showSecurityQuestions {
                    SecurityQuestionView(authenticationManager: authenticationManager, questionManager: questionManager) {
                        showSecurityQuestions = false
                        isAuthenticated = true // Moveforward to ContentView as normal
                    }
                }
                
                else if showVerifySecurityQuestions {
                    SecurityQuestionsVerificationView(authenticationManager: authenticationManager, questionManager: questionManager) {
                        showVerifySecurityQuestions = false
                        isResettingPIN = true // Allow the user to reset their pin
                    }
                }
                
                // PIN reset flow after verifying security questions
                else if isResettingPIN {
                    Text("You can now reset your PIN.")
                        .font(.headline)
                        .padding(.bottom, 20)
                    
                    SecureField("Enter new PIN", text: $newPin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                    
                    Button("Set New PIN") {
                        if authenticationManager.changePIN(newPin: newPin) {
                            isResettingPIN = false
                            newPin = ""
                            isAuthenticated = true
                        } else {
                            pinSetupFailed = true
                        }
                    }
                    .padding()
                    if pinSetupFailed {
                        Text("Failed to reset PIN. Try again.")
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                }
                
                // PIN Authentication Flow
                else {
                    // enter PIN prompt will show if PIN is strored
                    Text("Enter your PIN")
                        .font(.headline)
                    
                    SecureField("Enter PIN", text: $pin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                    
                    Button("Unlock") {
                        if !isLockedOut {
                            if authenticationManager.authenticateUser(pin: pin) {
                                //If authentication succeeds
                                authenticationFailed = false
                                failedAttempts = 0 // Resetting failed attempts counter
                                pin = ""
                                
                                // Check if security questions are set
                                if authenticationManager.areSecurityQuestionsSet() {
                                    isAuthenticated = true // setting true intiates NavigationLink
                                    print("Authenticated successfully")
                                }
                            } else {
                                // Add error message if auth fails here
                                authenticationFailed = true
                                failedAttempts += 1 // incrementing failed attempts by 1
                                pin = ""
                                print("[DEBUG] Invalid PIN entered.")
                                
                                // Checking number of failed attempts
                                if failedAttempts >= 5 {
                                    isLockedOut = true
                                    startLockoutTimer() // Starting cooldown timer
                                }
                            }
                        }
                    }
                    .padding()
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(isLockedOut) //Disabling button if locked out
                    
                    // Forgot PIN button
                    Button("Forgot PIN?") {
                        isForgotPIN = true
                        showVerifySecurityQuestions = true
                    }
                    .padding(.top, 10)
                    
                    // Error message displays if auth fails
                    if authenticationFailed {
                        Text("Invalid PIN. Please try again.")
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                    
                    // Display lockout message if the user is locked out
                    if isLockedOut {
                        Text("Too many failed attempts. Try again in \(setLockoutTimer) seconds.")
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                }
                
                // Navigate to ContentView if authentication is succesful
                NavigationLink(
                    destination: ContentView(),
                    isActive: $isAuthenticated,
                    label: { EmptyView() }
                )
                
            }
            .onAppear{
                // Check if a PIN is already stored
                showSetPIN = !authenticationManager.isPINStored()
                if authenticationManager.isPINStored() && !authenticationManager.areSecurityQuestionsSet() {
                    showSecurityQuestions = true
                }
            }
            .navigationTitle("PIN Authentication")
            .padding()
        }
    }
    
    // Function to start the cooldown timer
    private func startLockoutTimer() {
        var lockoutTimer = setLockoutTimer
        timer?.invalidate() // Invalidate any existing timers
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            lockoutTimer -= 1
            
            if lockoutTimer <= 0 {
                isLockedOut = false // removing locked out flag so user can try again
                timer?.invalidate()
                timer = nil
            }
        }
    }
}
